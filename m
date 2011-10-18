From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] acltools: install them in $bindir, not $sbindir
Date: Tue, 18 Oct 2011 07:07:48 -0400
Message-ID: <20111018070748.0f6dfe40@corrin.poochiereds.net>
References: <1316803289-17016-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316803289-17016-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Sep 2011 14:41:29 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Move the manpages to section 1 since getcifsacl and setcifsacl are user,
> not sysadmin tools. Get rid of the useless sed calls on the manpages.
> They don't have any explicit paths in them that need replacing.
> 
> Also get rid of the "4.0" in the footers of all the manpages.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am                     |   15 ++++++---------
>  cifs.idmap.8.in                 |    2 +-
>  cifs.upcall.8.in                |    2 +-
>  getcifsacl.8.in => getcifsacl.1 |    4 ++--
>  mount.cifs.8                    |    2 +-
>  setcifsacl.8.in => setcifsacl.1 |    2 +-
>  6 files changed, 12 insertions(+), 15 deletions(-)
>  rename getcifsacl.8.in => getcifsacl.1 (94%)
>  rename setcifsacl.8.in => setcifsacl.1 (97%)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 7d4bdea..026be9f 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -8,6 +8,7 @@ mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
>  
>  man_MANS = mount.cifs.8
>  
> +bin_PROGRAMS =
>  sbin_PROGRAMS =
>  clean-local: clean-local-upcall clean-local-idmap clean-local-aclprogs
>  
> @@ -31,7 +32,7 @@ if CONFIG_CIFSUPCALL
>  endif
>  
>  if CONFIG_CIFSCREDS
> -bin_PROGRAMS = cifscreds
> +bin_PROGRAMS += cifscreds
>  cifscreds_SOURCES = cifscreds.c resolve_host.c util.c
>  cifscreds_LDADD = -lkeyutils
>  endif
> @@ -52,20 +53,16 @@ if CONFIG_CIFSIDMAP
>  endif
>  
>  if CONFIG_CIFSACL
> -sbin_PROGRAMS += getcifsacl
> +bin_PROGRAMS += getcifsacl
>  getcifsacl_SOURCES = getcifsacl.c
>  getcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
> -man_MANS += getcifsacl.8
> +man_MANS += getcifsacl.1
>  
> -sbin_PROGRAMS += setcifsacl
> +bin_PROGRAMS += setcifsacl
>  setcifsacl_SOURCES = setcifsacl.c
>  setcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
> -man_MANS += setcifsacl.8
> +man_MANS += setcifsacl.1
>  
> -getcifsacl.8: getcifsacl.8.in
> -	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> -setcifsacl.8: setcifsacl.8.in
> -	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
>  endif
>  
>  clean-local-aclprogs:
> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
> index f2fa3b2..7e3ab1f 100644
> --- a/cifs.idmap.8.in
> +++ b/cifs.idmap.8.in
> @@ -7,7 +7,7 @@
>  .\"    Source: cifs-utils 4.0
>  .\"  Language: English
>  .\"
> -.TH "CIFS\&.IDMAP" "8" "05/26/2011" "cifs-utils 4\&.0" "System Administration tools"
> +.TH "CIFS\&.IDMAP" "8" "05/26/2011" "cifs-utils" "System Administration tools"
>  .\" -----------------------------------------------------------------
>  .\" * set default formatting
>  .\" -----------------------------------------------------------------
> diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> index 03842b7..0d79a99 100644
> --- a/cifs.upcall.8.in
> +++ b/cifs.upcall.8.in
> @@ -7,7 +7,7 @@
>  .\"    Source: cifs-utils 4.0
>  .\"  Language: English
>  .\"
> -.TH "CIFS\&.UPCALL" "8" "02/07/2010" "cifs-utils 4\&.0" "System Administration tools"
> +.TH "CIFS\&.UPCALL" "8" "02/07/2010" "cifs-utils" "System Administration tools"
>  .\" -----------------------------------------------------------------
>  .\" * set default formatting
>  .\" -----------------------------------------------------------------
> diff --git a/getcifsacl.8.in b/getcifsacl.1
> similarity index 94%
> rename from getcifsacl.8.in
> rename to getcifsacl.1
> index 02e1355..7ad7f36 100644
> --- a/getcifsacl.8.in
> +++ b/getcifsacl.1
> @@ -7,7 +7,7 @@
>  .\"    Source: cifs-utils 4.0
>  .\"  Language: English
>  .\"
> -.TH "GETCIFSACL" "8" "08/19/2011" "cifs-utils 4\&.0" "System Administration tools"
> +.TH "GETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
>  .\" -----------------------------------------------------------------
>  .\" * set default formatting
>  .\" -----------------------------------------------------------------
> @@ -44,7 +44,7 @@ Display a security descriptor in raw mode. Values such as type and flags are dis
>  .PP
>  \fBmount.cifs\fR(8),
>  \fBwinbindd\fR(8),
> -\fBsetcifsacl\fR(8)
> +\fBsetcifsacl\fR(1)
>  .PP
>  .SH "AUTHOR"
>  .PP
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index af49319..054e898 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -7,7 +7,7 @@
>  .\"    Source: cifs-utils 4.0
>  .\"  Language: English
>  .\"
> -.TH "MOUNT\&.CIFS" "8" "02/07/2010" "cifs-utils 4\&.0" "System Administration tools"
> +.TH "MOUNT\&.CIFS" "8" "02/07/2010" "cifs-utils" "System Administration tools"
>  .\" -----------------------------------------------------------------
>  .\" * set default formatting
>  .\" -----------------------------------------------------------------
> diff --git a/setcifsacl.8.in b/setcifsacl.1
> similarity index 97%
> rename from setcifsacl.8.in
> rename to setcifsacl.1
> index 98ab0ac..ef1cc23 100644
> --- a/setcifsacl.8.in
> +++ b/setcifsacl.1
> @@ -7,7 +7,7 @@
>  .\"    Source: cifs-utils 4.0
>  .\"  Language: English
>  .\"
> -.TH "SETCIFSACL" "8" "08/19/2011" "cifs-utils 4\&.0" "System Administration tools"
> +.TH "SETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
>  .\" -----------------------------------------------------------------
>  .\" * set default formatting
>  .\" -----------------------------------------------------------------

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
