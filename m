From: Jeff Layton <jlayton@redhat.com>
Subject: Re: shrinking set of cifs fixes to merge for 2.6.39 to small set
Date: Tue, 12 Apr 2011 07:51:44 -0400
Message-ID: <20110412075144.53180566@corrin.poochiereds.net>
References: <BANLkTi=72h+nv9BfB+1e69tW4Hb_u5U_TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=72h+nv9BfB+1e69tW4Hb_u5U_TA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 11 Apr 2011 20:33:42 -0500
Steve French <smfrench@gmail.com> wrote:

> Since it is already past the merge window (was waiting to discuss some
> fixes with others at the fs summit last week before merge),  I shrunk
> the list of cifs patches waiting for merge (in cifs-2.6.git) to a much
> smaller set of more critical ones. See below. (I moved the others
> temporarily to a for-2.6.40 branch in cifs-2.6.git).  We (Jeff,
> Shirish, I etc.) need to build/test more with this set before sending
> though.
> 
> Jeff Layton (8):
>       cifs: check for private_data before trying to put it
>       cifs: replace /proc/fs/cifs/Experimental with a module parm

	I think we should also put in the patch that adds the
	page_mkwrite handler. Otherwise, we'll be adding an interface
	(new module parm) that we're just going to rip out later.

>       cifs: always do is_path_accessible check in cifs_mount
>       cifs: fix broken BCC check in is_valid_oplock_break
>       cifs: set ra_pages in backing_dev_info
>       cifs: clean up length checks in check2ndT2
>       cifs: clean up various nits in unicode routines (try #2)
>       cifs: wrap received signature check in srv_mutex
> 
> Steve French (6):
>       Allow user names longer than 32 bytes
>       Max share size is too small
>       Elminate sparse __CHECK_ENDIAN__ warnings on port conversion
>       various endian fixes to cifs
>       [CIFS] cifs: clarify the meaning of tcpStatus == CifsGood
>       [CIFS] Warn on requesting default security (ntlm) on mount
> 
> 

Other than that, this looks like a reasonable set. I'll plan to build
it later today and give it some testing.

-- 
Jeff Layton <jlayton@redhat.com>
