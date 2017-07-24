From: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: PROBLEM: CIFS SMB2/SMB3 does not work for domain based DFS
Date: Mon, 24 Jul 2017 10:21:57 -0500
Message-ID: <CAJUwKM10_89n8506C_m=u0iZuY=OBA00Dyzh=tXN_=E3njMA1w@mail.gmail.com>
References: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0@EXCHANGE.totemo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0-Xnr6BND5kcg95swH8otnYdHuzzzSOjJt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

see thread "cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)"

I can confirm smb > 1 + DFS works as expected with kernel >= 4.11. I
have, however, seen similar spurious errors/failures.

On Tue, Jul 18, 2017 at 4:47 AM, Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> I am having problems mounting a domain based DFS share using mount.cifs with the parameter vers=2.0 or vers=3.0, even though it works with the deprecated version vers=1.0.
>
> My test setup includes two separated Windows 2016 servers (180days eval iso), with the following roles:
>
> * on the first I'm running the domain controller (DC)
> * on the second VM I installed the DFS Namespace Root role (DFSN) and this VM also serves the actual shares
>
> Now, when trying to mount, the following error occurs:
>
> mount //domain.dev.com/files/sales /smb -o user=Administrator,password=xxxxxx,vers=3.0
>
> CIFS VFS: BAD_NETWORK_NAME: \\domain.dev.com\files
> CIFS VFS: session ffff88003bd0c000 has no tcon available for a dfs referral request
> CIFS VFS: cifs_mount failed w/return code = -2
>
> It's working fine, with SMB1. It does also work, when I specify the DFSN server directly:
>
> mount //dfsn/files/sales /smb -o user=Administrator,password=xxxxxx,vers=3.0
>
> From my point of view it looks like there is no resolution attempt of resolving the domain based UNC (//domain.dev.com/files) into the actual dfsroot representation.
>
> Since my domain controller doesn't host the dfsroot structure, any attempts resolving on it directly will fail.
>
> I tried initially with Kernel 4.11 but also build a recent 4.13 with the same issues.
> Latest keyutils (/sbin/key.dns_resolver) are in place and configured on the system.
>
> Do you need any further scripts/explanations how I set up the test servers? It's nothing special, everything sticks to the defaults.
>
> Best,
> Robert
>
> Totemo Support
>
> phone: +41 44 914 99 00
> fax: +41 44 914 99 99
>
> email: support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org
> web: www.totemo.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
