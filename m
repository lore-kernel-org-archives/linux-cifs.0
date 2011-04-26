From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH v4 1/6] cifs: Extract DFS referral expansion logic to
	separate function
Date: Tue, 26 Apr 2011 13:40:00 +0200
Message-ID: <20110426114000.GE7809@cobija.connexer.com>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net> <4DB65B74.7050706@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DB65B74.7050706-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Suresh,

On Tue, Apr 26, 2011 at 11:13:16AM +0530, Suresh Jayaraman wrote:
>> +static int
>> +expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
> 				^^^ Did you mean struct cifsSesInfo ?
>
> I'm not seeing any other patch renaming cifsSesInfo to cifs_ses. Or Am I  
> missing something. Sorry about pitching in so late..
> 			
> The compiler gives a warning, but nevertheless it compiles... looks odd.

this is based on steve's master/for-next branch, which among other things
has commit 1c1c95b7b97ee797832c0f973419983faa4761ed, which renames
cifsSesInfo to cifs_ses.  IIRC that was the only thing different between
the two branches, so if you'd like to try it against the mainline kernel
you can probably just re-rename the struct back to struct cifsSesInfo.


	sean
