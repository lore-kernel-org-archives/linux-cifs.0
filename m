From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 5 Aug 2010 16:12:53 -0400
Message-ID: <20100805161253.51ca6f97@tlielax.poochiereds.net>
References: <CC75E34383A8445493DD41AF4F7E7857@lan.jax.org.ru>
	<20100721100503.672a735e@tlielax.poochiereds.net>
	<9DFCDE0105DF4B70AEA82A8A2B2A2A94@lan.jax.org.ru>
	<20100722093121.4c64b102@barsoom.rdu.redhat.com>
	<54DA210795E649C1A62B5E10BF366BB3@lan.jax.org.ru>
	<20100804073140.5734d1bb@tlielax.poochiereds.net>
	<9EE2EFBFF2304A849754EEE0F1C1CE29@lan.jax.org.ru>
	<20100805140329.069baa41@barsoom.rdu.redhat.com>
	<583072918FF1484C9380D991E5A4E83C@lan.jax.org.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <583072918FF1484C9380D991E5A4E83C-PUkIMHyhFB22ZuJnPpCLiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 5 Aug 2010 22:48:21 +0400
"Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > I pulled down your latest code and it doesn't appear to be patched. Am
> > I missing something?
> 
> ----------------[snip]---------------
> struct command {
>  int (*action)(int argc, char *argv[]);
>  const char name[MAX_COMMAND_SIZE];
>  const char *format;
> };
> ----------------[snip]---------------
> 
> Now, under each field we will allocate exactly MAX_COMMAND_SIZE bytes.
> During the comparison we will not walk outside the allocated area.
> 
> ----------------[snip]---------------
>  n = strnlen(argv[1], MAX_COMMAND_SIZE);
> 
>  for (cmd = commands; cmd->action; cmd++) {
>   if (memcmp(cmd->name, argv[1], n) != 0)
>    continue;
> ----------------[snip]---------------

Ahh ok, thanks for clarifying. I had envisioned fixing this another
way, but this should be fine.

Now that that's fixed, I think this piece is pretty much done. When you
get time, please post it as a patch to cifs-utils to the linux-cifs
mailing list so that others can comment. If no one has objections, I'll
plan to merge it soon.

> Yes, I have developed an algorithm and wrote some code samples.
> This will require some changes in mount.cifs. The kernel will look for the 
> key during parsing of pass= option in cifs_parse_mount_options routine. As 
> an option pass= follows the options ip=, user= and dom= problems shouldn't 
> arise. If successful, password will be used from the key, otherwise from the 
> pass= option. mount.cifs can independently verify the presence of the key 
> and does not require a password from the user.

Cool -- I look forward to seeing that part.

I don't think however that you should assume that mount options come in
any particular order. We do occasionally get people who use cifs
without a mount helper at all or who pass in options that the mount
helper would ordinarily fill out itself (ip=, for instance).

Nice work!
--
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
