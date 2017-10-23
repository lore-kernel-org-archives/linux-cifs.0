From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] man: generate all man pages from POD files when
 buidling
Date: Mon, 23 Oct 2017 08:31:40 -0400
Message-ID: <1508761900.5859.10.camel@samba.org>
References: <20170920222053.7977-1-aaptel@suse.com>
         <20170929140303.24880-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170929140303.24880-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-09-29 at 16:03 +0200, Aurelien Aptel wrote:
> Move all man pages to easily editable POD files and generate troff
> source when building.
> 
> Previous .in troff file are still preprocessed before final generation
> to use configured path (.pod.in -> .pod -> troff). All temporary
> files (.pod.in and troff sources) are properly deleted on clean.
> 
> Remove all troff file, no need to keep generated copies under source
> control.
> 
> This commit does not change the content of the man pages but makes
> future editing easier.
> 
> Adds a new --enable-man/--disable-man configure option to control the
> generation and installation of man pages. The option is automatically
> enabled if the system supports it. Explicitely enabling it will make the
> configure script fail if pod2man is not installed.
> 
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
> 
> changes in v2:
> 
> * add the configure flag for man page generation
> * check/autodetect if pod2man is available
> 
>  Makefile.am                   |  88 ++--
>  cifs.idmap.8.in               | 101 -----
>  cifs.idmap.pod.in             | 100 +++++
>  cifs.upcall.8.in              | 132 ------
>  cifs.upcall.pod.in            | 147 +++++++
>  cifscreds.1                   | 200 ---------
>  configure.ac                  |  21 +
>  getcifsacl.1.in               |  59 ---
>  getcifsacl.pod.in             |  60 +++
>  idmapwb.8.in                  | 148 -------
>  idmapwb.pod => idmapwb.pod.in |   0
>  mount.cifs.8                  | 856 --------------------------------------
>  mount.cifs.pod                | 933 ++++++++++++++++++++++++++++++++++++++++++
>  pam_cifscreds.8               | 207 ----------
>  pam_cifscreds.pod             |   2 +-
>  setcifsacl.1.in               | 113 -----
>  setcifsacl.pod.in             | 117 ++++++
>  17 files changed, 1431 insertions(+), 1853 deletions(-)
>  delete mode 100644 cifs.idmap.8.in
>  create mode 100644 cifs.idmap.pod.in
>  delete mode 100644 cifs.upcall.8.in
>  create mode 100644 cifs.upcall.pod.in
>  delete mode 100644 cifscreds.1
>  delete mode 100644 getcifsacl.1.in
>  create mode 100644 getcifsacl.pod.in
>  delete mode 100644 idmapwb.8.in
>  rename idmapwb.pod => idmapwb.pod.in (100%)
>  delete mode 100644 mount.cifs.8
>  create mode 100644 mount.cifs.pod
>  delete mode 100644 pam_cifscreds.8
>  delete mode 100644 setcifsacl.1.in
>  create mode 100644 setcifsacl.pod.in

Hi Aurelien,

I merged this patch but now I'm having a little buyer's remorse...

I originally used POD docs for some of these because it was easy and
I was familiar with it, and I wasn't aware of ReStructuredText.

The kernel however is moving to .rst files, which are just as simple as
.pod files to work with, and a bit more standard:

    http://docutils.sourceforge.net/docs/user/rst/quickstart.html

Would we be better off moving to RST as the canonical format for the
docs here? I think it'd be fairly trivial to do. There is a pod2rst
converter already:

    http://search.cpan.org/~dowens/Pod-POM-View-Restructured-0.02/bin/pod2rst

A one time conversion to rst files and twiddle the Makefile.am to use
rst2man and I think we'd be done. I'm happy to do the work, but I wanted
to run it by you in case you had a particular attachment to pod files.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
