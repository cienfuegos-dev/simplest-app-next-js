import {exampleApiConfig, firebaseConfig} from "../env";

export const EnvCard = () => (
    <div>
        <code>API key: {firebaseConfig.apiKey}</code>
        <br/>
        <code>API url: {exampleApiConfig.apiUrl}</code>
    </div>
);
