best = function (state , outcome) {
      
      data = read.csv("outcome-of-care-measures.csv" , stringsAsFactors=F)
      if(outcome == "heart attack") {
            outcome = names(data)[11]
      }else if (outcome == "heart failure"){
            outcome = names(data)[17]
      }else if (outcome == "pneumonia"){
            outcome = names(data)[23]
      }else {
            stop("invalid outcome")
      }

      isOk = F
      for (i in 1:length(data$State) ){
            if (state == data$State[i]){
                  isOk = T
                  break
            }
      }
      
      if (!isOk){
            stop("invalid state")
            #throw error
      }
      
      
      data = data[,c("Hospital.Name",outcome,"State")]
      data = data[,][data$State==state ,]
      data = data[,][data[,outcome] != "Not Available",]
      menor = 100
      r = vector()
      
      for (i in 1:nrow(data)) {
            if ( as.numeric(data[i , outcome]) < menor){
                  menor = as.numeric(data[i,outcome])
            }            
      }
      
      for (i in 1:nrow(data)) {
            if ( as.numeric(data[i , outcome]) == menor ) {
                  r = c(r,data[i,"Hospital.Name"])
            }
            
      }      
      
      sort(r)[1]
      
}


