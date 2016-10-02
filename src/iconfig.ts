export interface IConfig {
	maintainer: string;
	url: string;
	port: number;
	https: {
		enable: boolean;
		key: string;
		cert: string;
		ca: string;
	};
	recaptcha: {
		siteKey: string;
		secretKey: string;
	};
	core: {
		apikey: string;
		url: string;
	};
	proxy: {
		url: string;
	};
}
