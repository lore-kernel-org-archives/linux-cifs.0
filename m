From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Drop cached dentry if its metadata changed
Date: Wed, 2 Dec 2015 14:45:44 +0000
Message-ID: <565F0418.70102@citrix.com>
References: <1445260986-1886-1-git-send-email-ross.lagerwall@citrix.com>
 <CAH2r5mvsfV07CGQj61hExObi9CJWvZEpQvuC5UjxHax80LNS7g@mail.gmail.com>
 <5626019F.7020606@citrix.com>
 <CAH2r5mvPaFAD2mE=AfQUwh6B0324Gwf16kRnp4-=JodqvSxQyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvPaFAD2mE=AfQUwh6B0324Gwf16kRnp4-=JodqvSxQyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/20/2015 06:22 PM, Steve French wrote:
> On Tue, Oct 20, 2015 at 3:55 AM, Ross Lagerwall
> <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>> On 10/19/2015 05:21 PM, Steve French wrote:
>>>
>>> Could you verify this over SMB2 (vers=3.0) as well?  It looks like it
>>> should fail because cifs_all_info_to_fattr doesn't see the inode
>>> attribute change and fill in the new inode number  (IndexNuber).  I am
>>> suspicious that your patch is overkill (sends an extra request on
>>> revalidate, doubling the traffic) in the SMB2/SMB3 case since we are
>>> already doing a query file with FILE_ALL_INFO requested which already
>>> returned IndexNumber (so should have already gotten the inode number)
>>> - probably more important to use the IndexNumber we got back rather
>>> than request it twice.
>>
>>

I've found commit 7196ac113a4f ("Fix to check Unique id and FileType 
when client refer file directly."), which fixes the same problem for 
when UNIX extensions are enabled. I will submit the same fix for SMB2+ 
(since you've already got the uniqueid without needing to issue an extra 
network request).

-- 
Ross Lagerwall
