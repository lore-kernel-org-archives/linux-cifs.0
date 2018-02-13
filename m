From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH stable] cifs: empty TargetInfo leads to crash on recovery
Date: Tue, 13 Feb 2018 16:38:13 +0100
Message-ID: <20180213153813.GA5919@kroah.com>
References: <20180127200741.57298-1-dan@kernelim.com>
 <20180128144348.GA19937@kroah.com>
 <20180128145220.GA47771@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        stable@vger.kernel.org, linux-cifs@vger.kernel.org
To: Dan Aloni <dan@kernelim.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180128145220.GA47771@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Jan 28, 2018 at 04:52:20PM +0200, Dan Aloni wrote:
> On Sun, Jan 28, 2018 at 03:43:48PM +0100, Greg KH wrote:
> > On Sat, Jan 27, 2018 at 10:07:41PM +0200, Dan Aloni wrote:
> > > commit cabfb3680f78 upstream.
> > 
> > Are you sure?
> > $ gsr cabfb3680f78
> > cabfb3680f78 ("CIFS: Enable encryption during session setup phase")
> > 
> > Doesn't seem to match up at all here :(
> 
> That's only because it fixed the issue unknownly, accordingly to
> git-bisectings I've done. Should I have not added 'commit <githash>
> upstream.' in that case? stable_kernel_rules.txt is not so clear
> about it.

I need the git commit id of the patch that is in Linus's tree in order
to apply it to the stable tress.  And the text and comments and change
needs to match.  To have a different subject would be really confusing.

You can put a note in the changelog body that says

[note this fixes issue x and y - myname]

which is what some people do.

Care to fix this up and resend?

thanks,

greg k-h
