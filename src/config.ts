import {IConfig} from './iconfig';
import load from './load-config';
import { themeColor, themeColorForeground } from './meta';

let conf: IConfig & {
	themeColor: string;
	themeColorForeground: string;
	host: string;
	hosts: any;
	domains: any;
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

const domains = conf.domains = {
	about: 'about',
	color: 'color',
	help: 'help',
	i: 'i',
	resources: 'resources',
	signup: 'signup',
	signin: 'signin',
	signout: 'signout',
	share: 'share',
	search: 'search',
	talk: 'talk'
};

// Define hosts
conf.hosts = {
	i: `${domains.i}.${host}`,
	about: `${scheme}${domains.about}.${host}`,
	signup: `${domains.signup}.${host}`,
	signin: `${domains.signin}.${host}`,
	signout: `${domains.signout}.${host}`,
	share: `${domains.share}.${host}`,
	search: `${domains.search}.${host}`,
	talk: `${domains.talk}.${host}`,
	help: `${domains.help}.${host}`,
	color: `${domains.color}.${host}`
};

// Define URLs
conf.urls = {
	i: `${scheme}://${domains.i}.${host}`,
	about: `${scheme}://${domains.about}.${host}`,
	signup: `${scheme}://${domains.signup}.${host}`,
	signin: `${scheme}://${domains.signin}.${host}`,
	signout: `${scheme}://${domains.signout}.${host}`,
	share: `${scheme}://${domains.share}.${host}`,
	search: `${scheme}://${domains.search}.${host}`,
	talk: `${scheme}://${domains.talk}.${host}`,
	help: `${scheme}://${domains.help}.${host}`,
	color: `${scheme}://${domains.color}.${host}`
};

export default conf;
