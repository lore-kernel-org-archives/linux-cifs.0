From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: SMB2: Enforce sec= mount option
Date: Tue, 10 Jan 2017 15:30:08 -0800
Message-ID: <58756E80.5000802@tlinx.org>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481179577-15995-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin Prabhu wrote:
> If the security type specified using a mount option is not supported,
> the SMB2 session setup code changes the security type to RawNTLMSSP. We
> should instead fail the mount and return an error.
>   
---
Saw the comment by Steve F, and it got me to thinking.
Please take this as a suggestion or idea...  I'm not
heavily committed to a single solution, at this point, as
haven't really thought through all of the ramifications.

Is it possible to add a 'prefix' or 'suffix', like an
"=" sign or a '+' -- to mean:

'=' = exactly this 'sec' level
'+' = this 'sec'-level or greater
'<' = less than or equal to this sec-level
---
Using the symbols is a similar idea to some fields in
'find' where +/- are used to indicate greater or less than
the stated number.

I'm not sure about the symbols, exactly, but I know in samba I
ask for smb2 for the protocol and more often than not, only
get smb1, but I'd rather have it work than fail.

Since I'm on a closed net, I'd have to say the same for
security options, but I'd like to have a choice to force it
if I wanted to...

Anyway -- just an idea that might offer more flexibility than just
'fail'...
