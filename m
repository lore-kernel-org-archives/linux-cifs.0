From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Regression] commit 81bcd8b7 breaks CIFS mount
Date: Thu, 13 Dec 2012 23:05:18 -0600
Message-ID: <CAH2r5msqxf0mTLLuY3c0e1ZO7W3-+6Z_ig572k48d9NUo-O_Rg@mail.gmail.com>
References: <19417714.1234541355460245243.JavaMail.weblogic@epv6ml05>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jongman.heo-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19417714.1234541355460245243.JavaMail.weblogic@epv6ml05>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows 7 should support nltmspp.

First verify that mounting with ntlm (e.g. specifying "sec=ntlm" on
mount) works (after that unmount and also try mounting with
"sec=ntlmv2" to see if "raw" ntlmv2 instead of ntlmv2 in ntlmssp
works).  Second check your registry setting on Windows 7 server to
make sure that you did not disable ntlmv2

On Thu, Dec 13, 2012 at 10:44 PM, Jongman Heo <jongman.heo-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>
> Hi,
>
> commit 81bcd8b7 breaks CIFS mount in my Fedora 16 and Fedora 17 machines, with following error message.
>
>     [   51.119251] Status code returned 0xc000005e NT_STATUS_NO_LOGON_SERVERS
>     [   51.119259] CIFS VFS: Send error in SessSetup = -5
>     [   51.119476] CIFS VFS: cifs_mount failed w/return code = -5
>
> FYI, remotetarget is Windows 7.
>
> Reverting the commit 81bcd8b7 fixes the mount problem.
>
> I read the commit message, is this intended behavior?
> Then how can I resolve my issue withour reverting the commit?
> Need to install some package, or change system configuration?
>
>
> git bisect log attached.
>
> # git bisect log
> git bisect start '--' 'fs/cifs'
> # bad: [66cdd0ceaf65a18996f561b770eedde1d123b019] Merge tag 'kvm-3.8-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> git bisect bad 66cdd0ceaf65a18996f561b770eedde1d123b019
> # good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
> git bisect good 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
> # bad: [1cc9bd68617f2a92dcd6e4398288341d16cfb5c1] make convert_delimiter use strchr instead of open-coding it
> git bisect bad 1cc9bd68617f2a92dcd6e4398288341d16cfb5c1
> # bad: [d3d1fce11dbbf4246f1c37839b13757f08aec3b7] cifs: don't override the uid/gid in getattr when cifsacl is enabled
> git bisect bad d3d1fce11dbbf4246f1c37839b13757f08aec3b7
> # bad: [852e22950dc47e774bb602b16f55fed42afac5fb] cifs: use the NUM_AUTHS and NUM_SUBAUTHS constants in cifsacl code
> git bisect bad 852e22950dc47e774bb602b16f55fed42afac5fb
> # bad: [60654ce047f7be62afa291573501e011297a47d8] cifs: fix types on module parameters
> git bisect bad 60654ce047f7be62afa291573501e011297a47d8
> # bad: [81bcd8b795229c70d7244898efe282846e3b14ce] default authentication needs to be at least ntlmv2 security for cifs mounts
> git bisect bad 81bcd8b795229c70d7244898efe282846e3b14ce



-- 
Thanks,

Steve
