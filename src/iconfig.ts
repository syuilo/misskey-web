export interface IConfig {
	maintainer: string;
	host: string;
	port: number;
	https: {
		enable: boolean;
		key: string;
		cert: string;
		ca: string;
	};
	sessionSecret: string;
	recaptcha: {
		siteKey: string;
		secretKey: string;
	};
	core: {
		apikey: string;
		host: string;
		port: number;
		www: string;
	};
	redis: {
		host: string;
		port: number;
		pass: string;
	};
}
