export interface IConfig {
	maintainer: string;
	host: string;
	bindIp: string;
	port: number;
	bindPort: number;
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
	api: {
		key: string;
		host: string;
		port: number;
		secure: boolean;
		internal: {
			host: string;
			port: number;
		};
	};
	mongodb: {
		host: string;
		db: string;
		user: string;
		pass: string;
	};
	redis: {
		host: string;
		port: number;
		pass: string;
	};
}
