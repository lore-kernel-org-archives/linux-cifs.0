From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 21:50:40 +0100
Message-ID: <24172.1277844640@redhat.com>
References: <1277843319.4500.17.camel@heimdal.trondhjem.org> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1277843319.4500.17.camel@heimdal.trondhjem.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> There has been a lot of interest in allowing the user to specify exactly
> which fields they want the filesystem to return, and whether or not the
> kernel can use cached data or not. The main use is to allow
> specification of a 'stat light' that could help speed up
> "readdir()+multiple stat()" type queries. At last year's Filesystem and
> Storage Workshop, Mark Fasheh actually came up with an initial design:
> 
>    http://www.kerneltrap.com/mailarchive/linux-fsdevel/2009/4/7/5427274
> 
> If we're going to add in a whole new syscall for stat, should we perhaps
> revisit this discussion?

I could certainly absorb that patch.

One further consideration following on from what you said: Is it worth having
an extended getdents() that can return stat data too?  That might be useful
for NFS.

David
