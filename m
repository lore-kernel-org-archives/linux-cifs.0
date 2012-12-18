From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 0/5] cifs-utils: plugin interface for SID to UID/GID mapping
Date: Tue, 18 Dec 2012 09:10:43 -0500
Message-ID: <1355839848-24118-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second official posting for the plugin interface. Major
changes since the last set are:

1/ There's a header file now that plugin implementers are expected to use

2/ New manpage for idmapwb.so and cleanups to the existing manpages to
   discuss plugin configuration

3/ Better handling for the plugin_errmsg variable. A pointer to the
   pointer is passed into the init_plugin routine, which allows the
   setting of it in the context.

With this, I think I'm pretty close to something mergeable, but
comments and review are still appreciated.

Jeff Layton (5):
  cifs-utils: struct cifs_sid definition to new cifsidmap.h header
  cifs-utils: new plugin architecture for ID mapping code
  cifs-utils: convert setcifsacl to use the plugin interface
  cifs-utils: convert cifs.idmap to use plugin interface
  cifs-utils: add a manpage for idmapwb

 Makefile.am                     |  37 ++++--
 cifs.idmap.8.in                 |  22 ++--
 cifs.idmap.c                    |  93 +++++++--------
 cifsacl.h                       |  12 +-
 cifsidmap.h                     | 161 ++++++++++++++++++++++++++
 configure.ac                    |  10 ++
 getcifsacl.1 => getcifsacl.1.in |   5 +-
 getcifsacl.c                    |  98 +++++++---------
 idmap_plugin.c                  | 160 ++++++++++++++++++++++++++
 idmap_plugin.h                  |  61 ++++++++++
 idmapwb.8.in                    | 148 ++++++++++++++++++++++++
 idmapwb.c                       | 242 ++++++++++++++++++++++++++++++++++++++++
 idmapwb.pod                     |  26 +++++
 setcifsacl.1 => setcifsacl.1.in |   6 +-
 setcifsacl.c                    |  70 +++---------
 15 files changed, 952 insertions(+), 199 deletions(-)
 create mode 100644 cifsidmap.h
 rename getcifsacl.1 => getcifsacl.1.in (87%)
 create mode 100644 idmap_plugin.c
 create mode 100644 idmap_plugin.h
 create mode 100644 idmapwb.8.in
 create mode 100644 idmapwb.c
 create mode 100644 idmapwb.pod
 rename setcifsacl.1 => setcifsacl.1.in (91%)

-- 
1.7.11.7
