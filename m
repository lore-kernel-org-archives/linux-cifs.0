From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Sticky bit problem
Date: Fri, 17 Jun 2011 09:58:25 -0400
Message-ID: <20110617095825.3b097567@tlielax.poochiereds.net>
References: <0CCCA5445D7FCB4298BBF0739D4FDD52031DBFE7AEAD@EUEXCLU01.EU.NEC.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Aldrich <David.Aldrich-R48kc7GjPox+cjeuK/JdrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0CCCA5445D7FCB4298BBF0739D4FDD52031DBFE7AEAD-xQY3r3TrJtXs0DjMma/IH35yN64r8l2t@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Jun 2011 10:32:44 +0100
David Aldrich <David.Aldrich-R48kc7GjPox+cjeuK/JdrQ@public.gmane.org> wrote:

> Hi
> 
> We are building a Linux app under Centos 5.3, using gnu make 3.81 and gcc 4.12.  The working directory is on a remote machine and is either a Samba share or a Windows 7 share.  We find that in the case of a Windows 7 share the resulting executable has the sticky bit set in group:
> 
> On Windows 7 share:
> 
> -rwxrwSrwx 1 <snip> myapp
> 
> On Samba share:
> 
> -rwxrwx--x+ 1 <snip> myapp
> 
> The Sticky bit prevents another user in the group from executing the application.
> 
> Please will someone suggest how we can prevent the sticky bit from being set?
> 
> I found a reference on this list that may be relevant:
> 
> http://lists.samba.org/archive/linux-cifs-client/2007-October/002294.html
> 
> Is this a problem with the CIFS client?
> 
> Best regards
> 

That's actually not the sticky bit, but rather the sgid bit. The
capital S means that it doesn't have the group execute bit set, which
has a special meaning to the kernel -- it tells it to enforce mandatory
locking. You probably want to use the file_mode/dir_mode mount options
here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
