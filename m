From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Sat, 08 Jun 2013 16:28:26 +0200
Message-ID: <1370701706.6104.3.camel@hh16.hh3.site>
References: <51A32117.5030908@steve-ss.com>
	 <20130528063525.1baeac8c@corrin.poochiereds.net>
	 <1369744796.2769.8.camel@hh16.hh3.site>
	 <20130528090142.36d5076e@corrin.poochiereds.net>
	 <1369842745.3123.9.camel@hh16.hh3.site>
	 <20130529144555.595ee5a4@tlielax.poochiereds.net>
	 <1369860007.2278.19.camel@hh16.hh3.site>
	 <20130608090820.1f3bb0e2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130608090820.1f3bb0e2-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2013-06-08 at 09:08 -0400, Jeff Layton wrote:
> On Wed, 29 May 2013 22:40:07 +0200
> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> 
> > On Wed, 2013-05-29 at 14:45 -0400, Jeff Layton wrote:
> > > On Wed, 29 May 2013 17:52:25 +0200
> > > steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> > > 
> > > > On Tue, 2013-05-28 at 09:01 -0400, Jeff Layton wrote:
> > > > > >  How does this sound?
> > > > > > - I make a domain user called cifsuser with rfc2307 uidNumber and
> > > > > > gidNumber:
> > > > > > uid=3000025(cifsuser) gid=20513(Domain Users) groups=20513(Domain Users)
> > > > > > 
> > > > > > - I mount like this:
> > > > > > sudo kinit cifsuser
> > > > > > mount -t cifs //oliva/users /mnt -osec=krb5
> > > > > > (just tried it: fine)
> > > > > > 
> > > > > > -I stick cifsuser in the keytab and kinit -k it in a cron every few
> > > > > > hours or so to keep it alive.
> > > > > > 
> > > > > > Thanks so much for your time,
> > > > > > Steve
> > > > > > 
> > > > > 
> > > > > That sounds reasonable. Assuming that you don't actually do anything on
> > > > > the mount as root, then you can give "cifsuser" very limited privileges
> > > > > here too, essentially acting as a "squashed" user like under NFS.
> > > > > 
> > > > > Also, there's no need to do this crontab stuff either. If you mount
> > > > > with "-o sec=krb5,username=cifsuser" then cifs.upcall will be able to
> > > > > just use /etc/krb5.keytab without you needing to do anything special.
> > > > > 
> > > > 
> > > > 
> > > > Hi
> > > > OK. Nearly done. I now have the automounter working:
> > > > /etc/auto.users
> > > > * -fstype=cifs,rw,sec=krb5,username=cifsuser,multiuser ://oliva/users/&
> > > > 
> > > > It works fine except I have 2 keytabs per client.
> > > >  /etc/krb5.keytab
> > > > produced by
> > > >  net ads join
> > > > It contains the host/client and MACHINE$ keys 
> > > > and 
> > > >  /etc/cifs.keytab
> > > > produced the DC and copied to the clients which contains the cifsuser
> > > > keys.
> > > > 
> > > > Question: will cifs only look in /etc/krb5.keytab? Can I get it to look
> > > > at /etc/cifs.keytab instead? OK, I can ktutil merge them but. . .
> > > > 
> > > > Thanks for your patience.
> > > > 
> > > > 
> > > 
> > > Yes, it currently only looks at /etc/krb5.keytab. It probably wouldn't
> > > be very hard to add a new command-line option to give it an alternate
> > > one if that helps.
> > > 
> > > I do have a question here though. Why are you bothering with the
> > > automounter at all? Why not instead just mount //oliva/users via fstab
> > > at the point where auto.users is currently mounted?
> > > 
> > > That should give you the same effect with a much smaller mount table
> > > and no automounter overhead. Something like this in /etc/fstab ought to
> > > do it:
> > > 
> > >     //oliva/users  /path/to/top/of/users/dir   cifs  sec=krb5,username=cifsuser,multiuser 0 0
> > > 
> > Hi
> > Without the automounter, the fileserver grinds to a halt after around 20
> > users connect. A lot of our hardware is around 10 years old.
> > 
> 
> None of that should matter. The cifs client aggressively shares
> connections, so the server should see little difference either way in
> how the network traffic looks whether you have multiple mounts like
> this or a single multiuser mount.
> 
> The only thing I can think of that would be different would be that the
> automounter might umount on a shorter schedule, and hence you might end
> up with fewer SMB sessions to the server. If that's the case though,
> then you're likely to see the same problems with the autofs setup
> eventually. You just need a particularly busy period of the machine...
> 
> In any case, if you're seeing your server grind to a halt, then I think
> you'd be well-advised to try to figure out why that is. autofs
> shouldn't really be fixing anything here.
> 
> > Adding an option to select a different keytab for mount.cifs would be
> > great. e.g. a bit like the -t in:
> >  kinit -k cifsuser -t /etc/cifs.keytab
> > 
> 
> Adding such an option is reasonably trivial. Does the following patch
> work for you? If it does, it'll need a manpage update too.
> 
> --------------------[snip]----------------------
> 
> [PATCH] cifs.upcall: allow users to specify dedicated keytab on command-line
> 
> Currently cifs.upcall only looks at the default system keytab
> (/etc/krb5.keytab). It's often the case however that a dedicated keytab
> is desirable. Allow users to set one on the command-line.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 6c0b9de..5a6c7d7 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -805,13 +805,14 @@ lowercase_string(char *c)
>  
>  static void usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
> +	fprintf(stderr, "Usage: %s [ -d /path/to/keytab] [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
>  }
>  
>  const struct option long_options[] = {
>  	{"krb5conf", 1, NULL, 'k'},
>  	{"legacy-uid", 0, NULL, 'l'},
>  	{"trust-dns", 0, NULL, 't'},
> +	{"dedicated-keytab", 1, NULL, 'd'},
>  	{"version", 0, NULL, 'v'},
>  	{NULL, 0, NULL, 0}
>  };
> @@ -839,11 +840,14 @@ int main(const int argc, char *const argv[])
>  
>  	openlog(prog, 0, LOG_DAEMON);
>  
> -	while ((c = getopt_long(argc, argv, "ck:ltv", long_options, NULL)) != -1) {
> +	while ((c = getopt_long(argc, argv, "cd:k:ltv", long_options, NULL)) != -1) {
>  		switch (c) {
>  		case 'c':
>  			/* legacy option -- skip it */
>  			break;
> +		case 'd':
> +			keytab_name = optarg;
> +			break;
>  		case 't':
>  			try_dns++;
>  			break;
> -- 
> 1.8.1.4
> 

Hi
Brilliant.
I applied the patch, well, I edited cifs.upcall.c with the -'s and +'s
at least. I then, make clean, build and make install. I now have:
 cifs.upcall
Usage: cifs.upcall [ -d /path/to/keytab] [-k /path/to/krb5.conf] [-t]
[-v] [-l] key_serial

Looks good. Where do I put the -d in:
 mount -t cifs //altea/users /mnt -osec=krb5,multiuser,username=cifsuser
or don't I?
Cheers,
Steve
