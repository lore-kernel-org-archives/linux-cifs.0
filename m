From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 07/10] cifs: FS-Cache page management
Date: Wed, 23 Jun 2010 18:05:01 +0100
Message-ID: <9866.1277312701@redhat.com>
References: <1277220228-3635-1-git-send-email-sjayaraman@suse.de> <yes>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1277220228-3635-1-git-send-email-sjayaraman@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Takes care of invalidation and release of FS-Cache marked pages and also
> invalidation of the FsCache page flag when the inode is removed.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: David Howells <dhowells@redhat.com>
