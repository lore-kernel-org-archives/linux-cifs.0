Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D04476CE8;
	Fri,  2 Oct 2026 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935694; cv=none; b=GFDqgFN58tyYUjslySK23Zm4+ULOOZmNoHI6DMNA/ltY0bj6bsA++F6Pl+0JtgzDMiNlciXsk826e8DGQscKtb92R9PUi/SKdIKnvPNJ05Z+IYIh8XH+EDMfpiYZIioHwgzQbvj+kC3vYx/yjOLEEBvvIfMFlLn0QBKUATuANXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935694; c=relaxed/simple;
	bh=37qcnODRwYw7ndXTbNaEj8b8seuguwmGkztJcQl0AaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rq+Xbg4N6UvjxAH1B0fm36BPZ2ORfAXALSPxFR0p4ARkLuEGrAKukeMs3//xAsC+sJMiCGeC7GJYZhqKtMuk1EkkmwjvzGBZSkjXSV5CnCVm2fNIM6Z2D75tUp8dA2GJLf8H5GUBLD4v3Ta14ltAUAq1jTnHdK4DI5AqU0QR6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKj/ePF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKj/ePF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50151F000FF;
	Fri,  2 Oct 2026 10:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790935693;
	bh=LY9VxvcXwN76EizeDT/tvDrMhfgIEaCIidMTHshekyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKj/ePF6nHELeO2FNRdvzNz0hRjCk8BThq4MpGvDBAisk+vtScj48I6pdLshXBdpD
	 LsCSNuoOMwchDIVEcxcGLdy1c3BX0eRu1gaMCuYRDkWyNVNGk/fgOrlaiHBel93VTq
	 MbSlowB/eBsyHEBqzUsxgo6INyFboTuCGZONOZznhoCUrWeNCZ3zZD4GTz4BWklTz3
	 cmMPK+AtOSYkeZJmpu0qH9HzzzIBw18pm1gk6AIQYagN8NdB9l+XeEjNJcPb9evXdm
	 BMJ0qv5AS9K15prlFR3JRP2INdQiC64WIxcVBXeYARfhLUWr3NWX0cmN8ZzRh9DTO9
	 amynbNBsuFLuw==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: cachefiles: Fix unset error when calling netfs_prepare_write_failed()
Date: Fri,  2 Oct 2026 12:08:07 +0200
Message-ID: <20261002-zirkulation-serienweise-rodeln-6b433932eec4@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3227746.1790772118@warthog.procyon.org.uk>
References: <3227746.1790772118@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1137; i=brauner@kernel.org; h=from:subject:message-id; bh=37qcnODRwYw7ndXTbNaEj8b8seuguwmGkztJcQl0AaQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTtb+q49jVsw66SHWJc91bvOukql+s4v/tj9J+36c6fT +TNa707raOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiV5gZGZ7uCtP549bF6vpr h6n8nb25k742dP47otV5XdQqY/d0vi6Gf6YCOt+jA+e8DAoy2j/70PuJLkGPbq14+v6MzqMS39B Pt/gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 13:41:58 +0100, David Howells wrote:
> Fix cachefiles to set subreq->error before calling
> netfs_prepare_write_failed() otherwise netfslib will try (and fail) to
> retry the subrequest (it shouldn't retry writes to the cache, but rather
> abandon them).  This causes it to hang waiting for the request to complete.

Applied to the vfs-7.4.netfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.netfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.netfs

[1/1] cachefiles: Fix unset error when calling netfs_prepare_write_failed()
      https://git.kernel.org/vfs/vfs/c/04b0415fa18a
