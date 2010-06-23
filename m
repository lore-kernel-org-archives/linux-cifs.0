From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 04/10] cifs: define server-level cache index objects and register them with FS-Cache
Date: Wed, 23 Jun 2010 17:54:52 +0100
Message-ID: <9658.1277312092@redhat.com>
References: <1277220198-3522-1-git-send-email-sjayaraman@suse.de> <yes>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1277220198-3522-1-git-send-email-sjayaraman@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Define server-level cache index objects (as managed by TCP_ServerInfo
> structs).  Each server object is created in the CIFS top-level index object
> and is itself an index into which superblock-level objects are inserted.
> 
> Currently, the server objects are keyed by hostname.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Looks reasonable, apart from the index key.  I agree with Jeff that you
probably want {address,port,family} rather than a hostname.

David
