From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: SMB2: Enforce sec= mount option
Date: Thu, 12 Jan 2017 02:33:08 -0800
Message-ID: <58775B64.2030205@tlinx.org>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com> <58756A3D.6000705@tlinx.org> <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Scott Lovenberg wrote:
> It'd take a tiny bit of messing with the command line parser, but I'd
> be for that.  As a gesture of good faith, since I raised the issue,
> I'd be willing to submit the patch set for mount.cifs to support this
> if everyone is on board.  I'd suggest staying away from '<' and '>'
---
    Yeah, the '<' sent a shiver as I wrote it.  find uses "-5" means 
'<=5', but
the minus bothered me a bit, but perhaps less than the '<'.
Was looking at samba's switches they allow specifying "min" and "max"
for protocols, that could be written compactly with "proto=+smb1,-smb2.1",
or any number of more verbose options.  The options for auth+security seem
a bit less regular than always specifying a range, like some options 
automatically disable lower security options -- I suppose specifying
a 'max' isn't needed, since if once side offers a higher level that is
too high for the other, the other can just NACK during the negotiation.

Better get back to lurking now... ;-)
