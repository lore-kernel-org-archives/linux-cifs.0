From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH] cifs: Do not lookup hashed negative dentry in
 cifs_atomic_open
Date: Tue, 30 Oct 2012 19:20:17 +0000
Message-ID: <1351624817.3038.12.camel@localhost>
References: <1351615413-9182-1-git-send-email-sprabhu@redhat.com>
	 <CAKywueTnmyeGU+rW3kNdS0AV8Vu=0nd_=AHyB47jnRH8AAqqpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
	Steve French <smfrench@gmail.com>,
	Jeff Layton <jlayton@redhat.com>, vit.zahradka@tiscali.cz,
	linux-fsdevel@vger.kernel.org
To: Pavel Shilovsky <piastry@etersoft.ru>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKywueTnmyeGU+rW3kNdS0AV8Vu=0nd_=AHyB47jnRH8AAqqpA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 2012-10-30 at 22:30 +0400, Pavel Shilovsky wrote:
> >         if (!(oflags & O_CREAT)) {
> > +               /* Check for hashed negative dentry. We have already
> revalidated
> > +                * the dentry and it is fine. No need to perform
> another lookup.
> > +                */
> 
> Patch looks ok, but the comment above doesn't match the kernel
> CodingStyle for block comments. While cifs code has a many places
> where it doesn't follow the style, we should keep new code as clean as
> possible. 

Sorry about that. I had passed it through checkpatch.pl and it came out
fine. I checked the codestyle document and it appears that this style is
preferred only for files in net/ and drivers/net/. I am sending a v2 of
the patch with the small cosmetic change to ensure that it follows the
Coding Style.

Sachin Prabhu

