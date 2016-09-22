From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 22 Sep 2016 16:17:09 +0100
Message-ID: <1474557429.14139.10.camel@redhat.com>
References: <20160922150918.GA127053@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>,
        Steve French <sfrench@samba.org>,
        Aurelien Aptel <aaptel@suse.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160922150918.GA127053@ubuntu-hedt>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 2016-09-22 at 10:09 -0500, Seth Forshee wrote:
> We've received reports from users of a cifs mount regression in our
> 4.4-based kernel, e.g. [1]. It is fixed by reverting the follwing
> commit
> from 4.8 which was applied to 4.4 stable:
> 
>  a6b5058 fs/cifs: make share unaccessible at root level mountable
> 
> Testing against 4.8-rc7 shows that the problem is present there as
> well.
> 
> Thanks,
> Seth
> 
> [1] http://bugs.launchpad.net/bugs/1626112

Hello Seth, 

We have identified some regressions introduced by the mentioned patch
These include

a) mounting of DFS shares breaks. The fix is included in Steve's tree
at
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=de5233745cd59c
f5853d963ad216067788a87594

b) mounting of the same share with different paths breaks. Fixed by
upstream commit	c1d8b24d18192764fe82067ec6aa8d4c3bf094e0

c) memory leaks in mounting fixed by upstream 	4214ebf4654798309
364d0c678b799e402f38288

Can you please share any other reports not mentioned above?

Sachin Prabhu
