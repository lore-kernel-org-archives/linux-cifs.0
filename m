From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 1/6] cifs: Extract DFS referral expansion logic to
 separate function
Date: Tue, 26 Apr 2011 11:13:16 +0530
Message-ID: <4DB65B74.7050706@suse.de>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-1-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/06/2011 07:56 PM, Sean Finney wrote:
> The logic behind the expansion of DFS referrals is now extracted from
> cifs_mount into a new static function, expand_dfs_referral.  This will
> reduce duplicate code in upcoming commits.
>
> Reviewed-by: Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sean Finney<seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
> ---
>   fs/cifs/connect.c |  105 +++++++++++++++++++++++++++++++++++------------------
>   1 files changed, 69 insertions(+), 36 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 94e60c5..c89d871 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2742,6 +2742,57 @@ build_unc_path_to_root(const struct smb_vol *volume_info,
>   	full_path[unc_len + cifs_sb->prepathlen] = 0; /* add trailing null */
>   	return full_path;
>   }
> +
> +/*
> + * Perform a dfs referral query for a share and (optionally) prefix
> + *
> + * If a referral is found, mount_data will be set to point at a newly
> + * allocated string containing updated options for the submount.
> + * Otherwise it will be left untouched.
> + *
> + * Returns the rc from get_dfs_path to the caller, which can be used to
> + * determine whether there were referrals.
> + */
> +static int
> +expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
				^^^ Did you mean struct cifsSesInfo ?

I'm not seeing any other patch renaming cifsSesInfo to cifs_ses. Or Am I 
missing something. Sorry about pitching in so late..
			
The compiler gives a warning, but nevertheless it compiles... looks odd.

-- 
Suresh Jayaraman
