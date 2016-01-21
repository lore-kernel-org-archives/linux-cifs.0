From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] autoconf: Use $(DEFS) when building idmapwb.so and
 pam_cifscreds.so
Date: Wed, 20 Jan 2016 22:13:41 -0500
Message-ID: <20160120221341.3e3f3e25@synchrony.poochiereds.net>
References: <1452255879-2180-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452255879-2180-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  8 Jan 2016 17:54:39 +0530
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> We should pass the macros defined in $(DEFS) when building idmapwb.so
> and pam_cifscreds.so. The autoconf process sets the macro HAVE_CONFIG_H
> using the $(DEFS) variable. This macro has to be defined to allow the
> source files to include config.h
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Makefile.am | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 92da8b1..2e99e60 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -84,7 +84,7 @@ plugin_PROGRAMS = idmapwb.so
>  man_MANS += idmapwb.8
>  
>  idmapwb.so: idmapwb.c
> -	$(CC) $(CFLAGS) $(AM_CFLAGS) $(WBCLIENT_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ $(WBCLIENT_LIBS)
> +	$(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(WBCLIENT_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ $(WBCLIENT_LIBS)
>  
>  idmapwb.8: idmapwb.8.in
>  	$(SED) 's,[@]pluginpath@,$(pluginpath),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> @@ -95,7 +95,7 @@ if CONFIG_PAM
>  pam_PROGRAMS = pam_cifscreds.so
>  
>  pam_cifscreds.so: pam_cifscreds.c cifskey.c resolve_host.c util.c
> -	$(CC) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ -lpam -lkeyutils
> +	$(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ -lpam -lkeyutils
>  man_MANS += pam_cifscreds.8
>  endif
>  

Merged.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
