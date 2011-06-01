From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create man pages for cifs.idmap program
 (try #2)
Date: Wed, 1 Jun 2011 15:28:48 -0400
Message-ID: <20110601152848.3f396bcb@tlielax.poochiereds.net>
References: <1306951902-14115-1-git-send-email-shirishppargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306951902-14115-1-git-send-email-shirishppargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  1 Jun 2011 13:11:42 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Create man pages for program cifs.idmap
> Enable cifs.idmap config option by default.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am     |   14 ++++++++-
>  cifs.idmap.8.in |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  configure.ac    |    7 +++-
>  3 files changed, 108 insertions(+), 3 deletions(-)
>  create mode 100644 cifs.idmap.8.in
> 
> diff --git a/Makefile.am b/Makefile.am
> index 6046369..4938447 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -9,6 +9,7 @@ mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
>  man_MANS = mount.cifs.8
>  
>  sbin_PROGRAMS =
> +clean-local: clean-local-upcall clean-local-idmap
>  
>  if CONFIG_CIFSUPCALL
>  sbin_PROGRAMS += cifs.upcall
> @@ -22,8 +23,10 @@ man_MANS += cifs.upcall.8
>  #
>  cifs.upcall.8: cifs.upcall.8.in
>  	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> +endif
>  
> -clean-local:
> +clean-local-upcall:
> +if CONFIG_CIFSUPCALL
>  	rm -f cifs.upcall.8 cifs.upcall.8-t
>  endif
>  
> @@ -37,4 +40,13 @@ if CONFIG_CIFSIDMAP
>  sbin_PROGRAMS += cifs.idmap
>  cifs_idmap_SOURCES = cifs.idmap.c
>  cifs_idmap_LDADD = -lkeyutils $(WINB_LDADD)
> +man_MANS += cifs.idmap.8
> +
> +cifs.idmap.8: cifs.idmap.8.in
> +	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> +endif
> +
> +clean-local-idmap:
> +if CONFIG_CIFSIDMAP
> +	rm -f cifs.idmap.8 cifs.idmap.8-t
>  endif
> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
> new file mode 100644
> index 0000000..fb2e826
> --- /dev/null
> +++ b/cifs.idmap.8.in
> @@ -0,0 +1,90 @@
> +'\" t
> +.\"     Title: cifs.idmap
> +.\"    Author: [see the "AUTHOR" section]
> +.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
> +.\"      Date: 05/26/2011
> +.\"    Manual: System Administration tools
> +.\"    Source: cifs-utils 4.0
> +.\"  Language: English
> +.\"
> +.TH "CIFS\&.IDMAP" "8" "05/26/2011" "cifs-utils 4\&.0" "System Administration tools"
> +.\" -----------------------------------------------------------------
> +.\" * set default formatting
> +.\" -----------------------------------------------------------------
> +.\" disable hyphenation
> +.nh
> +.\" disable justification (adjust text to left margin only)
> +.ad l
> +.\" -----------------------------------------------------------------
> +.\" * MAIN CONTENT STARTS HERE *
> +.\" -----------------------------------------------------------------
> +.SH "NAME"
> +cifs.idmap \- Userspace helper for mapping ids for Common Internet File System (CIFS)
> +.SH "SYNOPSIS"
> +.HP \w'\ 'u
> +cifs\&.idmap [\-\-version|\-v] {keyid}
> +.SH "DESCRIPTION"
> +.PP
> +This tool is part of the cifs-utils suite\&.
> +.PP
> +cifs\&.idmap is a userspace helper program for the linux CIFS client filesystem\&. There are a number of activities that the kernel cannot easily do itself\&. This program is a callout program that does these things for the kernel and then returns the result\&.
> +.PP
> +cifs\&.idmap is generally intended to be run when the kernel calls request\-key(8)
> +for a particular key type\&. While it can be run directly from the command\-line, it is not generally intended to be run that way\&.
> +.PP
> +cifs\&.idmap works in conjuction with winbind facility of Samba suite to map owner and group SIDs to uids and gids respectively.  It is best utilized when
> +.br
> +\t\- a mount option of cifsacl is specified when mounting a cifs share
> +.br
> +\t\- winbind is specified as one of the search entries for passwd and group databases in file /etc/nsswitch.conf
> +.br
> +\t\- file smb.conf has winbind specific entries
> +.br
> +\t\- winbind daemon program is running
> +.br
> +.sp
> +In case winbind and cifs.idmap facilities are unavailable, file objects in a mounted share are assigned uid and gid of the credentials of the process that mounted the share.  So it is strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs respectively in case services of winbind and cifs.idmap facility are unavailable.  
> +.SH "OPTIONS"
> +.PP
> +\-\-version|\-v
> +.RS 4
> +Print version number and exit\&.
> +.RE
> +.SH "CONFIGURATION FOR KEYCTL"
> +.PP
> +cifs\&.idmap is designed to be called from the kernel via the request\-key callout program\&. This requires that request\-key be told where and how to call this program\&. Currently cifs\&.idmap handles a key type of:
> +.PP
> +cifs\&.idmap
> +.RS 4
> +This keytype is for mapping a SID to either an uid or a gid
> +.RE
> +.PP
> +To make this program useful for CIFS, you will need to set up entry for it in request\-key\&.conf(5)\&. Here is an example of an entry for this key type:
> +.sp
> +.if n \{\
> +.RS 4
> +.\}
> +.nf
> +#OPERATION  TYPE           D C PROGRAM ARG1 ARG2\&.\&.\&.
> +#=========  =============  = = ================================
> +create      cifs\&.idmap   * * @sbindir@/cifs\&.idmap %k
> +.fi
> +.if n \{\
> +.RE
> +.\}
> +.PP
> +See
> +\fBrequest-key.conf5\fR()
> +for more info on each field\&.
> +.SH "SEE ALSO"
> +.PP
> +
> +\fBrequest-key.conf\fR(5),
> +\fBmount.cifs\fR(8)
> +.SH "AUTHOR"
> +.PP
> +Shirish Pargaonkar wrote the cifs\&.idmap program\&.
> +.PP
> +The
> +Linux CIFS Mailing list
> +is the preferred place to ask questions regarding these programs\&.
> diff --git a/configure.ac b/configure.ac
> index 6cac703..e21f23e 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -26,7 +26,7 @@ AC_ARG_ENABLE(cifsidmap,
>  	[AC_HELP_STRING([--enable-cifsidmap],
>  			[Create cifs.idmap binary @<:@default=no@:>@])],
>  	enable_cifsidmap=$enableval,
> -	enable_cifsidmap="no")
> +	enable_cifsidmap="maybe")
>  
>  # Checks for programs.
>  AC_PROG_CC
> @@ -88,6 +88,9 @@ if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
>  				fi
>  				if test "$enable_cifsidmap" = "yes"; then
>  					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
> +				else
> +					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifs.idmap.])
> +					enable_cifsidmap="no"
>  				fi
>  			])
>  fi
> @@ -152,7 +155,7 @@ LIBS=$cu_saved_libs
>  
>  AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
>  AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
> -AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" = "yes"])
> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
>  
>  LIBCAP_NG_PATH
>  

Committed, along with a patch to clean up a few whitespace and minor manpage nits.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
