From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 11:56:21 -0400
Message-ID: <5086BE25.8080102@gmail.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350583669-12118-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/18/2012 2:07 PM, scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> This patch adds a warning when using NFS mounting syntax (server:/share), instead of the usual UNC syntax (//server/share || \\server\share), that support for NFS style mounts will be removed in version 6.0 of the mount.cifs utility.
>
> The reasoning for this is simple.  Support for NFS syntax is undocumented and increases maintenance overhead.  This came up recently on the cifs-utils list when discussing how to handle mounting a share NFS style using an IPv6 address. Since the ':' character is valid in a POSIX file path or share name it is an ambiguous delimiter.  Consider the following valid server share : "dead:beef::1:iSCSIExportedByIQN:storage".
>
> Instead of adding complicated code to the parser to support an undocumented feature, we're optin
> g to remove the feature in the mount utility in version 6.0 if there is no objection.
>
>
Jeff, it's been a few days and no one has objected (or really said 
anything).  Can we merge this patch?
