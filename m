From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] cifs: fix usage of d_materialise_unique in cifs_get_root
Date: Mon, 18 Jul 2011 18:54:23 +0100
Message-ID: <20110718175423.GE11013@ZenIV.linux.org.uk>
References: <1310990594-3570-1-git-send-email-jlayton@redhat.com>
 <20110718164501.GB11013@ZenIV.linux.org.uk>
 <20110718173454.GC11013@ZenIV.linux.org.uk>
 <20110718134942.0d06f203@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, piastryyy@gmail.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110718134942.0d06f203@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jul 18, 2011 at 01:49:42PM -0400, Jeff Layton wrote:

> Thanks, Al...
> 
> Looks good to me. I also gave it some basic smoke testing and it seems
> to do the right thing.
> 
> Reviewed-by: Jeff Layton <jlayton@redhat.com>

OK, it's in #for-linus2
