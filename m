From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs hangs when connecting
Date: Thu, 18 Apr 2013 15:40:16 +0100
Message-ID: <1366296016.6759.2.camel@localhost>
References: <CAJV-E0rWpTK08u3bFszkEHL69qEm0noh=LLmUmo_kY5aTxyORw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJV-E0rWpTK08u3bFszkEHL69qEm0noh=LLmUmo_kY5aTxyORw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2013-04-16 at 14:23 -0600, Daniel Taualii wrote:
> I have been connected to a share for years, and now after an update i
> can't mount it.  I can use smbclient to attach, but not mount -t cifs
> ...
> Below is my troubleshooting data:
> http://pastebin.com/qmvWve5n
> 
> 
> -Daniel

Hello Daniel,

The pastebin data is no longer available. 

The default security mechanism was changed recently and the remote
server may not be working well with the new security mechanism.
Can you please provide your kernel version.
Can you also try mounting with differing security mechanisms like
sec=ntlm, sec=ntlmv2, sec=ntlmv2i,  sec=ntlmssp, sec=ntlmsspi

Sachin Prabhu
