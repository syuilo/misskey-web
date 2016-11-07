import {IConfig} from './iconfig';
import load from './load-config';
import { themeColor, themeColorForeground } from './meta';

let conf: IConfig & {
	themeColor: string;
	themeColorForeground: string;
	host: string;
	hosts: any;
	urls: any;
};

try {
	// Load and parse the config
	conf = load();
} catch (e) {
	console.error('Failed to load config: ' + e);
	if (process) {
		process.exit(1);
	}
}

conf.themeColor = themeColor;
conf.themeColorForeground = themeColorForeground;

const host = conf.host = conf.url.substr(conf.url.indexOf('://') + 3);
const scheme = conf.url.substr(0, conf.url.indexOf('://'));

// Define hosts
const hosts = conf.hosts = {
	about: `about.${host}`,
	auth: `auth.${host}`,
	dev: `dev.${host}`,
	signup: `signup.${host}`,
	signin: `signin.${host}`,
	signout: `signout.${host}`,
	share: `share.${host}`,
	search: `search.${host}`,
	talk: `talk.${host}`,
	help: `help.${host}`
};

// Define URLs
conf.urls = {
	about: `${scheme}://${hosts.about}`,
	auth: `${scheme}://${hosts.auth}`,
	dev: `${scheme}://${hosts.dev}`,
	signup: `${scheme}://${hosts.signup}`,
	signin: `${scheme}://${hosts.signin}`,
	signout: `${scheme}://${hosts.signout}`,
	share: `${scheme}://${hosts.share}`,
	search: `${scheme}://${hosts.search}`,
	talk: `${scheme}://${hosts.talk}`,
	help: `${scheme}://${hosts.help}`
};

export default conf;
