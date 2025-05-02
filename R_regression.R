local_input_path <- "D:\\CodeStuff\\Stats\\colab_linear_regression\\linear_regression\\input\\RegressionDF_forR.csv" # nolint

regression_df <- read.csv(local_input_path)


install.packages(c("nlme", "MASS", "dplyr"))
library(nlme)
library(MASS)
library(dplyr)

#####################################################################################################################################################################################################################################################################################################################################################################################################################################################################################

fit_glmm_arma <- function(data,
                          response_var,
                          fixed_effects,
                          offset_var = NULL,
                          time_var,
                          group_var = NULL,
                          theta = 1,
                          ar_order = 1, # Ordem AR(p)
                          ma_order = 0) { # Ordem MA(q)

    require(nlme)
    require(MASS)
    require(dplyr)

    # Criar fórmula fixa
    fixed_part <- paste(response_var, "~", paste(fixed_effects, collapse = " + "))

    if (!is.null(offset_var)) {
        fixed_part <- paste(fixed_part, "+ offset(", offset_var, ")")
    }

    # Estrutura aleatória
    if (is.null(group_var)) {
        data$..group.. <- factor(1)
        random_formula <- ~ 1 | ..group..
        cor_formula <- as.formula(paste("~", time_var, "| ..group.."))
    } else {
        random_formula <- as.formula(paste("~ 1 |", group_var))
        cor_formula <- as.formula(paste("~", time_var, "|", group_var))
    }

    # Estrutura de correlação ARMA
    if (ar_order > 0 | ma_order > 0) {
        cor_struct <- corARMA(form = cor_formula, p = ar_order, q = ma_order)
    } else {
        cor_struct <- NULL
    }

    # Ajustar modelo
    model <- glmmPQL(
        fixed = as.formula(fixed_part),
        random = random_formula,
        family = negative.binomial(theta = theta),
        correlation = cor_struct,
        data = data,
        verbose = FALSE
    )

    return(model)
}

#######################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################


# Inicialize uma lista para guardar os modelos
models_list <- list()

# Loop para ajustar os modelos por região e armazenar na lista
for (reg in unique(regression_df$regiao)) {
    require(dplyr)
    cat("=============================================Rodando:", reg, "\n")
    reg_data <- regression_df %>% filter(regiao == reg)

    reg_data <- reg_data %>%
        ## Ajustar o modelo
        model() <- fit_glmm_arma(
        data = reg_data,
        response_var = "mental_health_visits",
        fixed_effects = c(
            "periodo", "Pandemia_Step", "Pandemia_Trend",
            "PosPandemia_Step", "PosPandemia_Trend", "cos1", "sin1"
        ),
        offset_var = "offset",
        time_var = "periodo",
        ar_order = 1,
        ma_order = 1,
    )

    # Armazenar o modelo na lista com a chave sendo a região
    models_list[[reg]] <- model

    # Imprimir o resumo do modelo para verificação
    print(summary(model))
}

########################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################



# Criar pastas para salvar os resultados
if (!dir.exists("acf_plots")) {
    dir.create("acf_plots")
}
if (!dir.exists("model_tests")) {
    dir.create("model_tests")
}

# Arquivo para salvar os testes Ljung-Box
sink(file = "model_tests/ljung_box_results.txt")

# Loop através de cada modelo na lista
for (reg in names(models_list)) {
    model <- models_list[[reg]]

    # Extrair resíduos normalizados
    res <- residuals(model, type = "normalized")

    # Gráficos ACF/PACF
    png(
        filename = paste0("acf_plots/", reg, "_acf_pacf.png"),
        width = 10, height = 5, units = "in", res = 300
    )
    par(mfrow = c(1, 2))

    # Plot ACF
    acf(res,
        main = paste("ACF -", reg),
        lag.max = 36,
        ylim = c(-0.5, 1)
    )

    # Plot PACF
    pacf(res,
        main = paste("PACF -", reg),
        lag.max = 36,
        ylim = c(-0.5, 1)
    )

    dev.off()

    # Teste Ljung-Box para diferentes lags
    cat("\n----------------------------------------\n")
    cat("Região:", reg, "\n")
    cat("Testes Ljung-Box para resíduos:\n\n")

    # Testar para lags específicos (1, 9, 12, 24, 25)
    for (lag in c(1, 9, 12, 24, 25)) {
        test <- Box.test(res, lag = lag, type = "Ljung-Box")
        cat(sprintf("Lag %2d: p-valor = %.4f", lag, test$p.value))

        # Adicionar asterisco para significância
        if (test$p.value < 0.05) {
            cat(" *")
            if (test$p.value < 0.01) cat("*")
            if (test$p.value < 0.001) cat("*")
        }
        cat("\n")
    }

    # Mostrar mensagem de progresso
    cat("Gráficos e testes gerados para:", reg, "\n")
}

# Fechar o arquivo de saída
sink()
