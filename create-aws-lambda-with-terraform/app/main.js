const aws= require("aws-sdk")

const s3= new aws.S3({ apiVersion: "2006-03-01" })

exports.handler= async (event) => {
  console.log(`received event : ${event}`)

  let responseMessage

  if(event.httpMethod === "GET")
    responseMessage= "GET request received!"

  else {
    const bucketName= event.bucket,
      keyName= decodeURIComponent(event.object.replace(/\+/g, ' '))

    try {
      const { Body }= await s3.getObject({ Bucket: bucketName, Key: keyName }).promise( )
      responseMessage= Body.toString("utf-8")
  
    } catch(error) {
      console.log(error)
      throw new Error(`Couldn't access S3 object ${keyName} in bucket ${bucketName}`)
    }
  }

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ message: responseMessage })
  }
}