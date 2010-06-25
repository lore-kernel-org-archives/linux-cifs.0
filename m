From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Fri, 25 Jun 2010 13:58:33 +0100
Message-ID: <22746.1277470713@redhat.com>
References: <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C24A4A0.90408@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Also, considering the UNC name of the resource (//server/share) may not
> be a good idea too as the cache will not be used when for e.g. IPaddress
> is used to mount.

You could convert the UNC name to an IP address, and just use that as your
key.

> > validate the root directory of the share in some way?
>
> I don't know if there is a way to do this.

Is there an inode number or something?  Even the creation time might do.

David
