From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 0/6] cifs-utils: plugin interface for
 name/SID/UID/GID mapping
Date: Wed, 2 Jan 2013 06:32:21 -0500
Message-ID: <20130102063221.3f4322cd@tlielax.poochiereds.net>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Dec 2012 07:50:27 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This is the third official posting of this patchset.
> 
> The main change since the last set is that the sid_to_id and id_to_sid
> calls have been changed to allow the mapping of multiple SIDs or IDs at
> once. The existing tools only need to map one at a time, but this
> anticipates the eventual need to map multiple IDs efficiently if and
> when RichACL support is merged into the kernel.
> 
> Also with this redesign, we can now handle IDMAP_BOTH properly as Metze
> suggested. The plugin API now passes back a type and the caller can
> decide how to handle the result.
> 
> Note that while working on this last iteration, it's become clear to me
> that the ACL handling code in the kernel is mis-designed in how it
> handles ownership. It's possible for files to be owned by groups under
> windows, and in that case the primary group owner may not be filled out.
> The kernel does not account for this possibility.
> 
> Fixing that will take a fundamental redesign, probably including a new
> upcall. I think this patchset represents the best we can do short of
> that.
> 
> Jeff Layton (6):
>   cifs-utils: struct cifs_sid definition to new cifsidmap.h header
>   cifs-utils: new plugin architecture for ID mapping code
>   cifs-utils: convert setcifsacl to use the plugin interface
>   cifs-utils: add autoconf test for WBC_ID_TYPE_BOTH
>   cifs-utils: convert cifs.idmap to use plugin interface
>   cifs-utils: add a manpage for idmapwb
> 
>  Makefile.am      |  45 +++++++--
>  aclocal/idmap.m4 |  15 +++
>  cifs.idmap.8.in  |  22 ++--
>  cifs.idmap.c     | 161 ++++++++++++++---------------
>  cifsacl.h        |  12 +--
>  cifsidmap.h      | 168 +++++++++++++++++++++++++++++++
>  configure.ac     |  13 +++
>  getcifsacl.1     |  58 -----------
>  getcifsacl.1.in  |  59 +++++++++++
>  getcifsacl.c     |  98 ++++++++----------
>  idmap_plugin.c   | 150 +++++++++++++++++++++++++++
>  idmap_plugin.h   |  57 +++++++++++
>  idmapwb.8.in     | 148 +++++++++++++++++++++++++++
>  idmapwb.c        | 301 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  idmapwb.pod      |  26 +++++
>  setcifsacl.1     | 111 --------------------
>  setcifsacl.1.in  | 113 +++++++++++++++++++++
>  setcifsacl.c     |  70 +++----------
>  18 files changed, 1231 insertions(+), 396 deletions(-)
>  create mode 100644 cifsidmap.h
>  delete mode 100644 getcifsacl.1
>  create mode 100644 getcifsacl.1.in
>  create mode 100644 idmap_plugin.c
>  create mode 100644 idmap_plugin.h
>  create mode 100644 idmapwb.8.in
>  create mode 100644 idmapwb.c
>  create mode 100644 idmapwb.pod
>  delete mode 100644 setcifsacl.1
>  create mode 100644 setcifsacl.1.in
> 

This set has now been merged.

I'll probably cut a new release within the next few days, so if you
have cifs-utils patches it might be a good idea to go ahead and post
them.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
