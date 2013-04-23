From: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Subject: Re: [PATCH RFC] cifs: revalidate directories instiantiated via FIND_*
 in order to handle DFS referrals
Date: Tue, 23 Apr 2013 11:59:45 +0200
Message-ID: <51765B91.5090100@prodrive.nl>
References: <1358276491-4835-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358276491-4835-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

On 01/15/2013 08:01 PM, Jeff Layton wrote:
> We've had a long-standing problem with DFS referral points. CIFS servers
> generally try to make them look like directories in FIND_FIRST/NEXT
> responses. When you go to try to do a FIND_FIRST on them though, the
> server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
> manifests as spurious EREMOTE errors back to userland.
>
> This patch attempts to fix this by marking directories that are
> discovered via FIND_FIRST/NEXT for revaldiation. When the lookup code
> runs across them again, we'll reissue a QPathInfo against them and that
> will make it chase the referral properly.
>
> There is some performance penalty involved here and no I haven't
> measured it -- it'll be highly dependent upon the workload and contents
> of the mounted share. To try and mitigate that though, the code only
> marks the inode for revalidation when it's possible to run across a DFS
> referral. i.e.: when the kernel has DFS support built in and the share
> is "in DFS".

Are you planning to get this patch into mainline?

I've applied this patch to 3.7.7, otherwise we where not able to mount 
dfs shares. It's running for over 2 months now on our servers and we 
have not seen any problems whatsoever.

Regards, Martijn

-- 
Martijn de Gouw
Engineer
Prodrive B.V.
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
