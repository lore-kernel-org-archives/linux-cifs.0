From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Mon, 4 Mar 2013 16:08:30 -0600
Message-ID: <CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q@mail.gmail.com>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Resending patch to a slightly broader list for last minute check if
anyone objects.  Although setting this particular socket option
(TCP_NODELAY) may not be as useful when corking/uncorking explicitly,
I want to doublecheck before removing them because there has been some
utility to the server allowing override of various sockopt options.
Samba server has long supported at least the following set of settable
socket options (although I don't know if the defaults are frequently
overridden now, by setting sockopts in smb.conf as used to be common
for the server).

SO_KEEPALIVE
SO_REUSEADDR
SO_BROADCAST
TCP_NODELAY
IPTOS_LOWDELAY
IPTOS_THROUGHPUT
SO_SNDBUF *
SO_RCVBUF *
SO_SNDLOWAT *
SO_RCVLOWAT *

* takes an integer argument rather than a boolean on/off

Any objections to removing the ability to set socket options
explicitly for the cifs network file system client?

On Thu, Feb 21, 2013 at 5:32 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> ...as promised for 3.9.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index d997737..8609c42 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -97,7 +97,7 @@ enum {
>         Opt_user, Opt_pass, Opt_ip,
>         Opt_unc, Opt_domain,
>         Opt_srcaddr, Opt_prefixpath,
> -       Opt_iocharset, Opt_sockopt,
> +       Opt_iocharset,
>         Opt_netbiosname, Opt_servern,
>         Opt_ver, Opt_vers, Opt_sec, Opt_cache,
>
> @@ -202,7 +202,6 @@ static const match_table_t cifs_mount_option_tokens =
> {
>         { Opt_srcaddr, "srcaddr=%s" },
>         { Opt_prefixpath, "prefixpath=%s" },
>         { Opt_iocharset, "iocharset=%s" },
> -       { Opt_sockopt, "sockopt=%s" },
>         { Opt_netbiosname, "netbiosname=%s" },
>         { Opt_servern, "servern=%s" },
>         { Opt_ver, "ver=%s" },
> @@ -1722,19 +1721,6 @@ cifs_parse_mount_options(const char *mountdata,
> const char *devname,
>                          */
>                         cFYI(1, "iocharset set to %s", string);
>                         break;
> -               case Opt_sockopt:
> -                       string = match_strdup(args);
> -                       if (string == NULL)
> -                               goto out_nomem;
> -
> -                       if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
> -                               printk(KERN_WARNING "CIFS: the "
> -                                       "sockopt=TCP_NODELAY option has
> been "
> -                                       "deprecated and will be removed "
> -                                       "in 3.9\n");
> -                               vol->sockopt_tcp_nodelay = 1;
> -                       }
> -                       break;
>                 case Opt_netbiosname:
>                         string = match_strdup(args);
>                         if (string == NULL)
> --
> 1.7.11.7
>



--
Thanks,

Steve
