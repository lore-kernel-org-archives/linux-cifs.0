From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/6] cifs: quit playing games with draining iovecs
Date: Tue, 19 Apr 2016 23:41:36 +0100
Message-ID: <20160419224136.GD25498@ZenIV.linux.org.uk>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
 <20160409205129.GI25498@ZenIV.linux.org.uk>
 <1461088397.15135.9.camel@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461088397.15135.9.camel@poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Apr 19, 2016 at 01:53:17PM -0400, Jeff Layton wrote:

> What's the advantage of using iov_iter_bvec over iov_iter_kvec ?

No need to screw with kmap() in the caller; moreover, when it comes to actual
copying it gets away with kmap_atomic() just around the memcpy(), which is
considerably cheaper.
