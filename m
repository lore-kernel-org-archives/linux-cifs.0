From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: remote_path_check for dfs causes extra tconX retries when
	invalid user or password
Date: Thu, 12 May 2011 10:24:56 +0200
Message-ID: <20110512082455.GA12662@cobija.connexer.com>
References: <BANLkTi=7KFzN5M4M7A2wFtbYCy2d4x+1xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTi=7KFzN5M4M7A2wFtbYCy2d4x+1xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hiya,

Given that I touched this code most recently, I feel morally compelled
to weigh in :)

On Wed, May 11, 2011 at 08:10:08AM -0500, Steve French wrote:
> When we get an access denied on SMB TConX (non existing userid will
> cause sessetup to succeed as guest but SMB tconX to fail) - we now
> unconditionally check for dfs path on any error in SMB TconX which
> results in 9 extra requests.  Perhaps we should check for rc == EACCES
> (in cifs_mount in fs/cifs/connect.c)
> 
> 	/* search for existing tcon to this server share */
> 	tcon = cifs_get_tcon(pSesInfo, volume_info);
> 	if (IS_ERR(tcon)) {
> 		rc = PTR_ERR(tcon);
> 		tcon = NULL;
> 		goto remote_path_check;
> 	}
> 
> or after remote_path_check label below:

I think in the first place should make sense.  I've only seen two
behaviors for remote DFS paths: "not covered" and "no such file or
directory".  So checking for EACCESS specifically, and short-circuiting
the remote checks in that case seems pretty reasonable to me, anyway.


	sean
