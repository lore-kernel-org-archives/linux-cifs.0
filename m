From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs hangs when connecting
Date: Thu, 18 Apr 2013 16:38:26 +0100
Message-ID: <1366299506.6759.5.camel@localhost>
References: <CAJV-E0rWpTK08u3bFszkEHL69qEm0noh=LLmUmo_kY5aTxyORw@mail.gmail.com>
	 <1366296016.6759.2.camel@localhost>
	 <CAJV-E0qB3u4pcLf-zG45cCchonRMi30_Skn-XwC_ZLctzoBW4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJV-E0qB3u4pcLf-zG45cCchonRMi30_Skn-XwC_ZLctzoBW4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2013-04-18 at 09:14 -0600, Daniel Taualii wrote:
> http://pastebin.com/nW1utsYB

>From the pastebin, 

[  156.124070] CIFS VFS: could not setup hash structures rc -110
[  156.124095] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[  156.124098] IP: [<ffffffff812deb2b>] crypto_larval_kill+0x2b/0x90
[  156.124104] PGD 226547067 PUD 22669f067 PMD 0
[  156.124108] Oops: 0002 [#1] SMP
[  156.124110] CPU 2
[  156.124111] Modules linked in: vmnet(O) vsock(O) vmci(O) vmmon(O)
ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE

You seem to have had an Oops. 
The message "CIFS VFS: could not setup hash structures rc -110" suggests
that there was a problem enabling the crypto structures which are used
for the hashing of the passwords and signing of packets.

Can you please provide the entire Oops message along with a few lines
which preceed it since it should contain the reason why we were not able
to allocate the structure.

Sachin Prabhu
