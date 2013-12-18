From: Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Subject: Re: Mounting error after upgrading to wheezy - Changes in mount.cifs
 from 4.5 to 5.5?
Date: Wed, 18 Dec 2013 18:43:52 +0100
Message-ID: <52B1DED8.9050001@phflesch.de>
References: <8f517d28f1398f0410e66e30d0aadd5a@localhost> <CAH2r5mv3yChbfKm0QBBZ=LymBx7Ssw6J_RmVMZQ1LJ8uDjLBuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv3yChbfKm0QBBZ=LymBx7Ssw6J_RmVMZQ1LJ8uDjLBuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

Am 18.12.2013 17:51, schrieb Steve French:
> I doubt that the sec=ntlm would make much of a difference but would be
> interesting to see what the access denied is coming back on - since
> from what you describe listing the contents of the root directory of
> the share should be permitted to both users so this is not an access
> denied on top of prefixpath issue as we had seen a few years ago.
Sorry, but perhaps I described the share-configuration not exact enough.
listing the contents is only allowed in the final (second) subdirectory, 
but not in the root of the share and not in the first subdirectory:

no    listing allowed        \\fs01\Share
no    listing allowed         \\fs01\Share\DepartmentA
         listing allowed         \\fs01\Share\DepartmentA\Stats

Greetings

Philipp
