From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Fri, 25 Jun 2010 22:46:38 +0100
Message-ID: <18628.1277502398@redhat.com>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net> <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com> <22697.1277470549@redhat.com>
Cc: dhowells@redhat.com, Suresh Jayaraman <sjayaraman@suse.de>,
	Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100625125306.7f9b1966@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Jeff Layton <jlayton@samba.org> wrote:

> Looks like it mostly uses the ctime. IMO, the mtime would be a better
> choice since it changes less frequently, but I don't guess that it
> matters very much.

I'd've thought mtime changes more frequently since that's altered when data is
written.  ctime is changed when attributes are changed.

Note that Ext4 appears to have a file creation time field in its inode
(struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?

David
