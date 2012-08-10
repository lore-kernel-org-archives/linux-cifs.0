From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How do I get the version of CIFS vfs with the backuid and
 backupgid on my system?
Date: Fri, 10 Aug 2012 09:41:52 -0500
Message-ID: <CAH2r5msnjMsDtLEiKY6DfAbZnS1uaayyBh6adO==f55bbNapmA@mail.gmail.com>
References: <2017228CAF598D4F8B68E7555B958761024E21C5@pr-pro-exch01-3.SMY.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Samuel Kidman <Samuel.Kidman-Z3GdMYdHZ+HQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2017228CAF598D4F8B68E7555B958761024E21C5-hwItHRsoPZXraSQBHSCtxdez543+lpuUZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

3.1 kernel included the backupuid and backupgid mount options.  The
3.4 kernel included a fix for this so that readdir ("ls" command)
passes the backup intent flag.  Version 12.04 of Ubuntu includes at
least a 3.2 kernel and would be fine for some backup applications, but
if you are running the previous version it does appear that there are
various apt-get repositories which contain newer kernels.

On Thu, Aug 9, 2012 at 10:03 PM, Samuel Kidman <Samuel.Kidman-Z3GdMYdHZ+HQT0dZR+AlfA@public.gmane.org> wrote:
> Hello
>
> My system is-
>
> 3.0.0-23-generic-pae #39-Ubuntu SMP Thu Jul 19 19:39:19 UTC 2012 i686
> i686 i386 GNU/Linux
>
> My goal is to mount a CIFS share and utilise backup intent to get read
> access to the CIFS share. However it seems that the version of CIFS vfs
> or the version of cifs-utils on my system isn't up to date enough to use
> this functionality. What is the correct version of CIFS vfs to install
> to get the backupuid and backupgid mounting options? How can this be
> installed in Ubuntu?
>
> Thanks.
>
> Sam Kidman
> IT System Administrator
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
