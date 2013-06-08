From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Sat, 08 Jun 2013 16:49:35 +0200
Message-ID: <1370702975.6763.1.camel@hh16.hh3.site>
References: <51A32117.5030908@steve-ss.com>
	 <20130528063525.1baeac8c@corrin.poochiereds.net>
	 <1369744796.2769.8.camel@hh16.hh3.site>
	 <20130528090142.36d5076e@corrin.poochiereds.net>
	 <1369842745.3123.9.camel@hh16.hh3.site>
	 <20130529144555.595ee5a4@tlielax.poochiereds.net>
	 <1369860007.2278.19.camel@hh16.hh3.site>
	 <20130608090820.1f3bb0e2@tlielax.poochiereds.net>
	 <1370701706.6104.3.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370701706.6104.3.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2013-06-08 at 16:28 +0200, steve wrote:
> On Sat, 2013-06-08 at 09:08 -0400, Jeff Layton wrote:
> >  cifs.upcall.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index 6c0b9de..5a6c7d7 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -805,13 +805,14 @@ lowercase_string(char *c)
> >  
> >  static void usage(void)
> >  {
> > -	fprintf(stderr, "Usage: %s [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
> > +	fprintf(stderr, "Usage: %s [ -d /path/to/keytab] [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
> >  }
> >  
> >  const struct option long_options[] = {
> >  	{"krb5conf", 1, NULL, 'k'},
> >  	{"legacy-uid", 0, NULL, 'l'},
> >  	{"trust-dns", 0, NULL, 't'},
> > +	{"dedicated-keytab", 1, NULL, 'd'},
> >  	{"version", 0, NULL, 'v'},
> >  	{NULL, 0, NULL, 0}
> >  };
> > @@ -839,11 +840,14 @@ int main(const int argc, char *const argv[])
> >  
> >  	openlog(prog, 0, LOG_DAEMON);
> >  
> > -	while ((c = getopt_long(argc, argv, "ck:ltv", long_options, NULL)) != -1) {
> > +	while ((c = getopt_long(argc, argv, "cd:k:ltv", long_options, NULL)) != -1) {
> >  		switch (c) {
> >  		case 'c':
> >  			/* legacy option -- skip it */
> >  			break;
> > +		case 'd':
> > +			keytab_name = optarg;
> > +			break;
> >  		case 't':
> >  			try_dns++;
> >  			break;
> > -- 
> > 1.8.1.4
> > 
> 
> Hi
> Brilliant.
> I applied the patch, well, I edited cifs.upcall.c with the -'s and +'s
> at least. I then, make clean, build and make install. I now have:
>  cifs.upcall
> Usage: cifs.upcall [ -d /path/to/keytab] [-k /path/to/krb5.conf] [-t]
> [-v] [-l] key_serial
> 
> Looks good. Where do I put the -d in:
>  mount -t cifs //altea/users /mnt -osec=krb5,multiuser,username=cifsuser
> or don't I?
> Cheers,
> Steve

Here is /etc/request-key.conf:

create	cifs.spnego	*	*		/usr/sbin/cifs.upcall -c %k
