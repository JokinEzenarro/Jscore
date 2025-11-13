function report=Jscore(X,Y,LVs)
%This function calculates and shows the J-Scores of a PLSR model with
%different number of Latent Variables. This score is intended to easily see
%the optimal number of LVs in the PLSR model for your data.

%X is the spectra and Y the reference data, samples in rows.
%LVs is the maximum number of LVs to calculate.

%WARNING: This code needs the Statistics and Machine Learning Toolbox
%(stats/stats), whose cross-validation function is in conflict with the one
% of the PLS_toolbox, so the latter one should be unprioritised.

%Author: Jokin Ezenarro
%Cite: doi.org/10.1016/j.chemolab.2023.104883

%Calculate the "peak resolution" of the spectra for the smoothing filter
    smoothing_points=smoothing_window(X);
%Calculation of the models
    for i=1:5 %Iterations for robustness
        clear RMSE
        clear BETA
        clear noise_index_beta
        
        for j=1:LVs
            [~,~,~,~,BETA1,PCTVAR,MSE,~] = plsregress(X,Y,j,'CV',10);
            
            BETA=BETA1(2:end)';            
            smooth_vector = smoothdata(BETA,2,'gaussian',smoothing_points);
            noise_index_beta1(j) = sqrt(sum((BETA-smooth_vector).^2))/sqrt(sum(BETA.^2));
            fitted_c=zeros(size(Y,1),10);
            for iteration=1:10
                c = cvpartition(size(Y,1),'KFold',10);
                clear X_train; clear Y_train; clear X_test; clear Tests
                for fold=1:10
                    idx_train = training(c,fold);
                    count_train=1;
                    count_test=1;
                    for sampl=1:size(Y,1)
                        if idx_train(sampl)==1
                            X_train(count_train,:)=X(sampl,:);
                            Y_train(count_train,1)=Y(sampl,:);
                            count_train=count_train+1;
                        else
                            X_test(count_test,:)=X(sampl,:);
                            Tests(count_test,1)=sampl;
                            count_test=count_test+1;
                        end
                    end
                    [~,~,~,~,BETA_temp,~,~,~] = plsregress(X_train,Y_train,j);
                    yfit = [ones(size(X_test,1),1) X_test]*BETA_temp;
                    for copy=1:count_test-1
                        fitted_c(Tests(copy,1),iteration)=yfit(copy,1);
                    end
                end
            end
            fitted_cv=mean(fitted_c,2);
            line = fitlm(Y,fitted_cv);   
            R2(j)=line.Rsquared.Adjusted;
        end
        EV = 1-cumsum(PCTVAR(2,:));
        RMSE1=sqrt(MSE(2,1:end));
        RMSE=RMSE1(1,2:LVs+1);
        
        [~,~,~,~,~,~,MSE,~] = plsregress(X,Y,LVs+1);
        RMSEc=sqrt(MSE(2,2:LVs+1));
        
        noise_index_beta=noise_index_beta1(1,1:LVs);
        RMSEind=1-(RMSEc./RMSE);
         invR2=1-R2;

        %Calculation of the J-Score
        Jscore(i,:)=((RMSE/std(Y))+RMSEind+noise_index_beta)/3;     
    end    
    meanJscore=mean(Jscore,1);

    %Creation of the report
    report.Jscore=meanJscore;
    report.invRPD=RMSE/std(Y);
    report.RMSEratio=RMSEind;
    report.noiseIndex=noise_index_beta;
    report.invR2=invR2;
    report.ResVar=EV;

    %Plot report
    figure
    tiledlayout(3,2)
    nexttile
    plot(report.invRPD)
    title('inverse RPD')
    ylim([0 1])
    nexttile
    plot(report.RMSEratio)
    title('1-RMSEcal/RMSEcv')
    ylim([0 1])
    nexttile
    plot(report.noiseIndex)
    title('Noise Index')
    ylim([0 1])
    nexttile
    plot(report.invR2)
    title('1-R2')
    ylim([0 1])
    nexttile
    plot(report.ResVar)
    title('Residual Variance')
    ylim([0 1])
    nexttile
    plot(report.Jscore)
    title('J-Score')
    ylim([0 1])
end