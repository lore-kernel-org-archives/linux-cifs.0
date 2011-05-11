From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: remote_path_check for dfs causes extra tconX retries when invalid
 user or password
Date: Wed, 11 May 2011 08:10:08 -0500
Message-ID: <BANLkTi=7KFzN5M4M7A2wFtbYCy2d4x+1xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we get an access denied on SMB TConX (non existing userid will
cause sessetup to succeed as guest but SMB tconX to fail) - we now
unconditionally check for dfs path on any error in SMB TconX which
results in 9 extra requests.  Perhaps we should check for rc == EACCES
(in cifs_mount in fs/cifs/connect.c)

	/* search for existing tcon to this server share */
	tcon = cifs_get_tcon(pSesInfo, volume_info);
	if (IS_ERR(tcon)) {
		rc = PTR_ERR(tcon);
		tcon = NULL;
		goto remote_path_check;
	}

or after remote_path_check label below:

	/*
	 * Perform an unconditional check for whether there are DFS
	 * referrals for this path without prefix, to provide support
	 * for DFS referrals from w2k8 servers which don't seem to respond
	 * with PATH_NOT_COVERED to requests that include the prefix.
	 * Chase the referral if found, otherwise continue normally.
	 */
	if (referral_walks_count == 0) {
		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
						cifs_sb, false);
		if (!refrc) {
			referral_walks_count++;
			goto try_mount_again;
		}
	}

-- 
Thanks,

Steve
