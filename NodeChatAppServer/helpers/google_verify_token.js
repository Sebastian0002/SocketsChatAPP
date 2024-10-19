const {OAuth2Client} = require('google-auth-library');

const client = new OAuth2Client();
const verifyGoogleIdToken = async ( token )=>{
    try {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: [
                "1606985865-n24stp2fcg61i1ris3dmv875aih7eas4.apps.googleusercontent.com",
                '1606985865-939b686fkua97eqn120nii25tsagj9qe.apps.googleusercontent.com',
                '1606985865-behjukfs3prsibtn43mhvnvscre331q4.apps.googleusercontent.com'
            ],  // Specify the CLIENT_ID of the app that accesses the backend
            // Or, if multiple clients access the backend:
            //[CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3]
        });
        const payload = ticket.getPayload();
        // const userid = payload['sub'];
        // If the request specified a Google Workspace domain:
        // const domain = payload['hd'];
        return {
            name : payload['name'],
            picture : payload['picture'],
            email : payload['email'],
        }

    } catch (error) {
        console.log(error);
        return null;
    }

    

}

module.exports = {
    verifyGoogleIdToken
}