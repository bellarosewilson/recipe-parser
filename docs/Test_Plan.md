# Recipe Manager - End-to-End Test Plan

## Test Environment

- Browser: Chrome, Firefox, Safari
- Devices: Desktop, Mobile (iOS/Android)
- Test Data: Sample recipe files (image) 3-5 

---

## 1. User Authentication Tests

### Sign Up

- [ ] Sign up with valid email/password → Success
- [ ] Sign up with invalid email format → Error shown
- [ ] Sign up with password < 6 chars → Error shown
- [ ] Sign up with mismatched password confirmation → Error shown
- [ ] Select preferred units (metric/imperial) → Saved correctly
- [ ] Redirect to recipes index after signup

### Sign In

- [ ] Sign in with correct credentials → Success
- [ ] Sign in with wrong password → Error shown
- [ ] Sign in with non-existent email → Error shown
- [ ] "Remember me" checkbox works
- [ ] Redirect to recipes index after login

### Sign Out

- [ ] Sign out successfully
- [ ] Redirect to landing page
- [ ] Cannot access protected routes after signout

### Password Reset

- [ ] Request password reset → Email sent
- [ ] Click reset link → Can set new password
- [ ] Login with new password works

---

## 2. Landing Page Tests

- [ ] Non-logged-in users see landing page at `/`
- [ ] Logged-in users redirect from `/` to `/recipes`
- [ ] All CTA buttons link correctly
- [ ] Navigation works (Sign Up, Sign In)
- [ ] Responsive on mobile/tablet/desktop
- [ ] Features section displays correctly

---

## 3. Recipe Upload & AI Parsing Tests

### File Upload

- [ ] Upload .jpg image → Accepted
- [ ] Upload .png image → Accepted
- [ ] Upload file > 10MB → Rejected with error
- [ ] Upload corrupted file → Error handled gracefully

### AI Parsing

- [ ] Image recipe parsed → Correct title extracted
- [ ] Image recipe parsed → Ingredients extracted with amounts/units
- [ ] Image recipe parsed → Steps extracted in order
- [ ] Complex recipe (20+ ingredients) → Parsed correctly (stretch goal)
- [ ] Recipe with special characters → Handled correctly (stretch goal)

### Upload Flow

- [ ] File uploads to AWS S3 → URL returned
- [ ] Loading state shown during parsing
- [ ] Parsed data displayed for review
- [ ] User can edit title before saving
- [ ] User can edit ingredients before saving
- [ ] User can edit steps before saving
- [ ] User can add missing ingredients
- [ ] User can add missing steps
- [ ] Recipe saves with all data to database
- [ ] Redirect to recipe show page after save

---

## 4. Recipe Management Tests

### Index Page

- [ ] All user's recipes displayed
- [ ] Recipe cards show title, ingredient count, date
- [ ] Pagination works (if 12+ recipes)
- [ ] Search by recipe name works
- [ ] "Upload New Recipe" button visible

### Show Page

- [ ] Recipe title displayed
- [ ] All ingredients listed correctly
- [ ] All steps listed in order (1, 2, 3...)
- [ ] "View Original File" link works
- [ ] Edit and Delete buttons visible
- [ ] Breadcrumbs navigation works

### Edit Recipe

- [ ] Can edit recipe title
- [ ] Can add new ingredient
- [ ] Can edit existing ingredient
- [ ] Can delete ingredient
- [ ] Can add new step
- [ ] Can edit existing step
- [ ] Can delete step
- [ ] Changes save correctly
- [ ] Cannot change original uploaded file

### Delete Recipe

- [ ] Delete button shows confirmation
- [ ] Confirm delete → Recipe removed
- [ ] Cancel delete → Recipe remains

---

## 5. Search & Filtering Tests

- [ ] Search by recipe name (exact match)
- [ ] Search by recipe name (partial match)
- [ ] Search returns correct results
- [ ] No results message when search fails
- [ ] Clear search works

---

## 6. User Profile Tests

- [ ] Profile page shows user email
- [ ] Can edit preferred units
- [ ] Changes save successfully
- [ ] Preferred units reflected in new recipe parsing

---

## 7. Authorization Tests

- [ ] User can only see their own recipes
- [ ] User cannot edit other user's recipes (URL manipulation)
- [ ] User cannot delete other user's recipes (URL manipulation)
- [ ] Unauthorized access redirects to login
- [ ] Logged-out users redirected to landing page

---

## 8. Email Notification Tests

- [ ] Confirmation email sent on recipe upload
- [ ] Email contains recipe title
- [ ] Email has link to recipe (link is stable, users can send link to external)
- [ ] Email formatted correctly

---

## 9. Performance Tests

- [ ] Recipe index loads in < 2 seconds
- [ ] Recipe show loads in < 1 second
- [ ] File upload completes in < 10 seconds
- [ ] AI parsing completes in < 30 seconds

---

## 10. Responsive Design Tests

### Mobile (375px width)

- [ ] Landing page renders correctly
- [ ] Navigation menu works
- [ ] Recipe cards
- [ ] Forms are usable
- [ ] File upload works
- [ ] All buttons tappable

### Tablet (768px width)

- [ ] Layout adjusts appropriately
- [ ] Navigation works
- [ ] Recipe grid displays correctly

### Desktop (1200px+ width)

- [ ] Full layout displays
- [ ] Navigation inline
- [ ] Recipe grid (3 columns)

---

## 11. Browser Compatibility Tests

- [ ] Chrome (latest)
- [ ] Safari (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

---

## 12. Edge Cases

- [ ] Very long step (1000+ characters)
- [ ] Simultaneous uploads from same user
- [ ] Poor network connection (slow upload)
- [ ] Session timeout during upload
- [ ] Duplicate recipe titles

---

## Test Summary

**Total Tests:** 100+
**Passed:** **_ / _**
**Failed:** **_ / _**
**Blocked:** **_ / _**

**Tested By:** [BRW]
**Date:** [On-Going]
**Environment:** [Production/Staging/Development]
```
