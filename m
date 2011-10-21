From: Terrence Shipclark <terrence.shipclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Fri, 21 Oct 2011 07:20:37 -0400
Message-ID: <4EA15585.4060802@gmail.com>
References: <4EA154FC.3090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EA154FC.3090601-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11-10-21 07:18 AM, Terrence Shipclark wrote:
> Hello,
>
> This is my first time posting to this list, and I hope I am not breaking
> any rules.
>
> I have been attempting to get the cifs kernel modules to mount the
> win2k8 dfs at my workplace. I did finally manage to get
> the dfs to mount after modifying the kernel module with this small patch
>
> @@ -3109,6 +3112,7 @@
> cifs_sb, false);
> if (!refrc) {
> referral_walks_count++;
> + rc=0;
> goto try_mount_again;
> }
> }
>
> Although I dont 100% understand what I did, as I had a hard time
> following the goto statements, I have a feeling that on initial setup it
> would follow the DFS referral, however ultimately fail as it exited
> because rc was still set to -6.
>
> So now For my second problem.
>
> Within the dfs tree there is a referral to //server/share$/folder. My
> user has access to //server/share$/folder, however do not have access to
> //server/$share. While following the referral the cifs module does a
> QUERY_PATH_INFO on \\server\share$\folder, and then is followed up by a
> QUERY_PATH_INFO on \\server\share$\ which rightfully returns a
> STATUS_ACCESS_DENIED from the server.
>
> Traversing the same path with smbclient \\server\share$ is never
> queried.Perhaps I am doing something wrong?
>
> I have been attempting to connect to this dfs from linux for about 2
> years,and this is the closest I have gotten, so any help would be
> appreciated.
>
> terry
