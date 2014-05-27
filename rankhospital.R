rankhospital = function (state, outcome, num = "best") {
      
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
      
      data[,outcome] = as.numeric(data[,outcome])
      
      data = data[order(data[outcome] , data["Hospital.Name"]) , ]
      
      if (num == "best"){
            num = 1
      }else if (num == "worst"){
            num = nrow(data)
      }
      
      as.character(data$Hospital.Name[num])
      
      
}
