From: David Aldrich <David.Aldrich-R48kc7GjPox+cjeuK/JdrQ@public.gmane.org>
Subject: FW: Sticky bit problem
Date: Fri, 17 Jun 2011 10:32:44 +0100
Message-ID: <0CCCA5445D7FCB4298BBF0739D4FDD52031DBFE7AEAD@EUEXCLU01.EU.NEC.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

We are building a Linux app under Centos 5.3, using gnu make 3.81 and gcc 4.12.  The working directory is on a remote machine and is either a Samba share or a Windows 7 share.  We find that in the case of a Windows 7 share the resulting executable has the sticky bit set in group:

On Windows 7 share:

-rwxrwSrwx 1 <snip> myapp

On Samba share:

-rwxrwx--x+ 1 <snip> myapp

The Sticky bit prevents another user in the group from executing the application.

Please will someone suggest how we can prevent the sticky bit from being set?

I found a reference on this list that may be relevant:

http://lists.samba.org/archive/linux-cifs-client/2007-October/002294.html

Is this a problem with the CIFS client?

Best regards

David
