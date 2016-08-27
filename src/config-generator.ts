import * as fs from 'fs';
import * as yaml from 'js-yaml';
import * as inquirer from 'inquirer';
import {IConfig} from './iconfig';
import {configPath, configDirPath} from './meta';

export default async function(): Promise<void> {
	const as: any = await inquirer.prompt([
		{
			type: 'input',
			name: 'maintainer',
			message: 'Maintainer name(and email address):'
		},
		{
			type: 'input',
			name: 'url',
			message: 'WWW URL:'
		},
		{
			type: 'input',
			name: 'port',
			message: 'Listen port:'
		},
		{
			type: 'confirm',
			name: 'https',
			message: 'Use TLS?',
			default: false
		},
		{
			type: 'input',
			name: 'https_key',
			message: 'Path of tls key:',
			when: (ctx: any) => ctx.https
		},
		{
			type: 'input',
			name: 'https_cert',
			message: 'Path of tls cert:',
			when: (ctx: any) => ctx.https
		},
		{
			type: 'input',
			name: 'https_ca',
			message: 'Path of tls ca:',
			when: (ctx: any) => ctx.https
		},
		{
			type: 'input',
			name: 'recaptcha_site',
			message: 'reCAPTCHA\'s site key:'
		},
		{
			type: 'input',
			name: 'recaptcha_secret',
			message: 'reCAPTCHA\'s secret key:'
		},
		{
			type: 'input',
			name: 'api_key',
			message: 'API key:'
		},
		{
			type: 'input',
			name: 'core_host',
			message: 'Core\'s host:',
			default: 'localhost'
		},
		{
			type: 'input',
			name: 'core_port',
			message: 'Core\'s port:'
		},
		{
			type: 'input',
			name: 'core_url',
			message: 'Core URL:'
		}
	]);

	const conf: IConfig = {
		maintainer: as.maintainer,
		url: as.url,
		port: parseInt(as.port, 10),
		https: {
			enable: as.https,
			key: as.https_key || null,
			cert: as.https_cert || null,
			ca: as.https_ca || null
		},
		recaptcha: {
			siteKey: as.recaptcha_site,
			secretKey: as.recaptcha_secret
		},
		core: {
			apikey: as.api_key,
			host: as.core_host,
			port: parseInt(as.core_port, 10),
			www: as.core_url
		}
	};

	console.log('Thanks, writing...');

	try {
		fs.mkdirSync(configDirPath);
		fs.writeFileSync(configPath, yaml.dump(conf));
		console.log('Well done.');
	} catch (e) {
		console.error(e);
	}
};
