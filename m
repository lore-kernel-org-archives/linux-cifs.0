From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] Add a dentry op to handle automounting rather than abusing follow_link() [ver #2]
Date: Mon, 26 Jul 2010 15:19:57 +0100
Message-ID: <9168.1280153997@redhat.com>
References: <1279944664.2944.8.camel@localhost> <20100722175847.5552.11520.stgit@warthog.procyon.org.uk> <17723.1279897759@redhat.com>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1279944664.2944.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Ian Kent <raven@themaw.net> wrote:

> >  (4) Stops pathwalk at the automount point and returns that point in the fs
> >      tree if it decides not to automount rather than reporting ELOOP (see its
> >      use of EXDEV for this).

Does it make autofs easier if d_op->d_automount() is allowed to return -EXDEV
to request this?  Then you can return it in Oz mode to allow the daemon to
see/use the underlying mountpoint without recursing back into d_automount().

Ideally, the daemon would use AT_NO_AUTOMOUNT, but there's no way to pass that
to sys_mount() or sys_umount().

David
