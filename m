From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: CIFS related seg fault (v2.6.37)
Date: Thu, 20 Jan 2011 05:18:43 +0000
Message-ID: <20110120051843.GO22723@ZenIV.linux.org.uk>
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>
 <4D37BDE4.1000104@suse.de>
 <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
 <4D37C1AE.7040100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
	Peter Teoh <htmldeveloper@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
	Jeff Layton <jlayton@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D37C1AE.7040100@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jan 20, 2011 at 10:31:34AM +0530, Suresh Jayaraman wrote:

> Sorry it was not a VFS fix but a fix from Al Viro that fixed this
> problem. IIUC, the commit has made it to cifs-2.6.git but not upstream.
> 
> commit 1c929cfe6d8f2087a337a868fbf6c38d56bb4889
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat Dec 18 11:43:51 2010 -0500
> 
>     switch cifs

It is in the mainline.  And there's no way anybody could've seen such
trace on .37 or earlier, since d_set_d_op() didn't exist before that.
